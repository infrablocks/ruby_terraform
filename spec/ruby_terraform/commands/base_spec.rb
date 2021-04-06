# frozen_string_literal: true

require 'spec_helper'

class TestWith < RubyTerraform::Commands::Base
  attr_reader :initialized

  @initialized = false

  def initialize_command
    @initialized = true
  end

  def parameter_defaults(_parameters)
    { default: 'value' }
  end

  def parameter_overrides(_parameters)
    { sample: 'overridden' }
  end

  def subcommands
    %w[apply]
  end

  def options
    %w[-sample]
  end

  def arguments(_parameters)
    ['an argument']
  end
end

class TestWithout < RubyTerraform::Commands::Base
  attr_reader :initialized

  @initialized = false
end

describe RubyTerraform::Commands::Base do
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
    it_behaves_like('an overridable parameter', [:binary, 'terraform'])

    it_behaves_like('an overridable parameter', [:logger, Logger.new($stdout)])

    it_behaves_like('an overridable parameter', [:stdin, ''])

    it_behaves_like('an overridable parameter', [:stdout, $stdout])

    it_behaves_like('an overridable parameter', [:stderr, $stderr])

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
    let(:parameters) { { sample: 'provided' } }
    let(:command_line) do
      instance_double(Lino::CommandLine, execute: nil)
    end
    let(:builder) do
      instance_double(
        Lino::CommandLineBuilder,
        build: command_line
      )
    end
    let(:subclass) { TestWith.new(options) }

    before do
      allow(RubyTerraform::Options::Factory)
        .to(receive(:from)
              .and_return([]))
      allow(Lino::CommandLineBuilder)
        .to(receive(:for_command)
              .and_return(builder))
      %i[
        with_options_after_subcommands
        with_option_separator
        with_appliables
        with_subcommands
        with_arguments
      ].each do |method|
        allow(builder).to(receive(method).and_return(builder))
      end

      subclass.execute(parameters)
    end

    it 'uses the options factory to compile the options to pass to lino' do
      expect(RubyTerraform::Options::Factory)
        .to(have_received(:from))
    end

    context 'when the subclass contains overrides for the Base defaults' do
      it 'applies the subclass options defaults and overrides to the ' \
         'supplied options' do
        expect(RubyTerraform::Options::Factory)
          .to(have_received(:from)
                .with(any_args, { default: 'value', sample: 'overridden' }))
      end

      it 'uses the switches provided by the subclass' do
        expect(RubyTerraform::Options::Factory)
          .to(have_received(:from)
                .with(['-sample'], any_args))
      end
    end

    context 'when the subclass does not contain overrides for the ' \
            'Base defaults' do
      let(:subclass) { TestWithout.new(options) }

      it 'uses the empty options defaults and overrides provided by Base' do
        expect(RubyTerraform::Options::Factory)
          .to(have_received(:from)
                .with(any_args, { sample: 'provided' }))
      end

      it 'uses the empty array of switches provided by Base' do
        expect(RubyTerraform::Options::Factory)
          .to(have_received(:from)
                .with([], any_args))
      end
    end
  end
end
