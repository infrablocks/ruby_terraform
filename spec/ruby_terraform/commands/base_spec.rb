require 'spec_helper'

class TestWith < RubyTerraform::Commands::Base
  attr_reader :initialized

  @initialized = false

  def initialize_command
    @initialized = true
  end

  def option_default_values(_values)
    { default: 'value' }
  end

  def option_override_values(_values)
    { sample: 'overridden' }
  end

  def sub_commands(_values)
    'apply'
  end

  def switches
    ['-sample']
  end

  def arguments(_values)
    'an argument'
  end
end

class TestWithout < RubyTerraform::Commands::Base
  attr_reader :initialized

  @initialized = false
end

module RubyTerraform
  module Commands
    describe Base do
      subject(:base) { described_class.new(options) }

      let(:options) do
        {
          binary: nil,
          logger: nil,
          stdin: nil,
          stdout: nil,
          stderr: nil
        }
      end
      let(:configuration) do
        instance_double(
          RubyTerraform::Configuration,
          binary: 'terraform',
          logger: logger,
          stdin: '',
          stdout: $stdout,
          stderr: $stderr
        )
      end
      let(:logger) do
        logger = Logger.new($stdout)
        logger.level = Logger::INFO
        logger
      end
      before do
        allow(RubyTerraform).to receive(:configuration).and_return(configuration)
      end

      shared_examples 'an overridable parameter' do |parameter, value|
        context "when no #{parameter} is supplied" do
          before { base }

          it 'uses the current value from the configuration' do
            expect(configuration).to have_received(parameter)
          end
        end

        context "when #{parameter} is supplied" do
          before do
            options[parameter] = value
            base
          end

          it 'uses the supplied value' do
            expect(configuration).not_to have_received(parameter)
          end
        end
      end

      describe '.new' do
        it_behaves_like 'an overridable parameter', [:binary, 'terraform']

        it_behaves_like 'an overridable parameter', [:logger, Logger.new($stdout)]

        it_behaves_like 'an overridable parameter', [:stdin, '']

        it_behaves_like 'an overridable parameter', [:stdout, $stdout]

        it_behaves_like 'an overridable parameter', [:stderr, $stderr]

        context 'when the subclass includes an initialize_command method' do
          let(:subclass) { TestWith.new(options) }

          it 'calls the method to initialize the subclass' do
            expect(subclass.initialized).to be_truthy
          end
        end

        context 'when the subclass does not include an initialize_command method' do
          let(:subclass) { TestWithout.new(options) }

          it 'calls the empty initialize_command in Base' do
            expect(subclass.initialized).to be_falsey
          end
        end
      end

      describe '#execute' do
        let(:opts) { { sample: 'provided' } }
        let(:lino_commandline) { instance_double(Lino::CommandLine, execute: nil) }
        let(:builder) { instance_double(RubyTerraform::CommandLine::Builder, build: lino_commandline) }
        let(:subclass) { TestWith.new(options) }

        before do
          allow(RubyTerraform::CommandLine::Builder).to receive(:new).and_return(builder)
          allow(RubyTerraform::CommandLine::OptionsFactory).to receive(:from).and_return([])

          subclass.execute(opts)
        end

        it 'uses the OptionsFactory to compile the options to pass to Lino' do
          expect(RubyTerraform::CommandLine::OptionsFactory).to have_received(:from)
        end

        it 'uses the Builder to supply the options to Lino' do
          expect(RubyTerraform::CommandLine::Builder).to have_received(:new)
        end

        context 'when the subclass contains overrides for the Base defaults' do
          it 'applies the subclass option defaults and overrides to the supplied options' do
            expect(RubyTerraform::CommandLine::OptionsFactory).to have_received(:from).with({ default: 'value', sample: 'overridden' }, any_args)
          end

          it 'uses the subcommand provided by the subclass' do
            expect(RubyTerraform::CommandLine::Builder).to have_received(:new).with(hash_including(sub_commands: 'apply'))
          end

          it 'uses the switches provided by the subclass' do
            expect(RubyTerraform::CommandLine::OptionsFactory).to have_received(:from).with(any_args, ['-sample'])
          end

          it 'uses the arguments provided by the subclass' do
            expect(RubyTerraform::CommandLine::Builder).to have_received(:new).with(hash_including(arguments: 'an argument'))
          end
        end

        context 'when the subclass does not contain overrides for the Base defaults' do
          let(:subclass) { TestWithout.new(options) }

          it 'uses the empty option defaults and overrides provided by Base' do
            expect(RubyTerraform::CommandLine::OptionsFactory).to have_received(:from).with({ sample: 'provided' }, any_args)
          end

          it 'uses the empty array of subcommands provided by Base' do
            expect(RubyTerraform::CommandLine::Builder).to have_received(:new).with(hash_including(sub_commands: []))
          end

          it 'uses the empty array of switches provided by Base' do
            expect(RubyTerraform::CommandLine::OptionsFactory).to have_received(:from).with(any_args, [])
          end

          it 'uses the empty array of arguments provided by Base' do
            expect(RubyTerraform::CommandLine::Builder).to have_received(:new).with(hash_including(arguments: []))
          end
        end
      end
    end
  end
end
