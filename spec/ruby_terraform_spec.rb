# frozen_string_literal: true

require 'spec_helper'

class RTIncluded
  include RubyTerraform
end

describe RubyTerraform do
  commands = {
    apply: RubyTerraform::Commands::Apply,
    clean: RubyTerraform::Commands::Clean,
    destroy: RubyTerraform::Commands::Destroy,
    format: RubyTerraform::Commands::Format,
    get: RubyTerraform::Commands::Get,
    import: RubyTerraform::Commands::Import,
    init: RubyTerraform::Commands::Init,
    output: RubyTerraform::Commands::Output,
    plan: RubyTerraform::Commands::Plan,
    refresh: RubyTerraform::Commands::Refresh,
    remote_config: RubyTerraform::Commands::RemoteConfig,
    show: RubyTerraform::Commands::Show,
    validate: RubyTerraform::Commands::Validate,
    workspace_list: RubyTerraform::Commands::WorkspaceList,
    workspace_select: RubyTerraform::Commands::WorkspaceSelect,
    workspace_new: RubyTerraform::Commands::WorkspaceNew,
    workspace_delete: RubyTerraform::Commands::WorkspaceDelete,
    workspace_show: RubyTerraform::Commands::WorkspaceShow
  }

  it 'has a version number' do
    expect(RubyTerraform::VERSION).not_to be nil
  end

  it 'allows commands to be run without configure having been called' do
    allow(Open4).to(receive(:spawn))

    described_class.apply(directory: 'some/path/to/terraform/configuration')
  end

  context 'configuration' do
    before do
      described_class.reset!
    end

    it 'logs to standard output by default' do
      expect do
        described_class
          .configuration
          .logger
          .info('Logging with the default logger.')
      end.to output(/Logging with the default logger./).to_stdout
    end

    it 'has info log level by default' do
      expect(described_class.configuration.logger.level).to eq(Logger::INFO)
    end

    it 'allows default logger to be overridden' do
      string_output = StringIO.new
      logger = Logger.new(string_output)
      logger.level = Logger::DEBUG

      described_class.configure do |config|
        config.logger = logger
      end

      described_class.configuration.logger
                     .debug('Logging with a custom logger at debug level.')

      expect(string_output.string)
        .to include('Logging with a custom logger at debug level.')
    end

    it 'has bare terraform command as default binary' do
      expect(described_class.configuration.binary).to eq('terraform')
    end

    it 'allows binary to be overridden' do
      described_class.configure do |config|
        config.binary = '/path/to/terraform'
      end
      expect(described_class.configuration.binary).to eq('/path/to/terraform')
    end

    it 'uses whatever $stdout points to for stdout by default' do
      expect(described_class.configuration.stdout).to eq($stdout)
    end

    it 'allows stdout stream to be overridden' do
      stdout = StringIO.new

      described_class.configure do |config|
        config.stdout = stdout
      end

      expect(described_class.configuration.stdout).to eq(stdout)
    end

    it 'uses whatever $stderr points to for stderr by default' do
      expect(described_class.configuration.stderr).to eq($stderr)
    end

    it 'allows stderr stream to be overridden' do
      stderr = StringIO.new

      described_class.configure do |config|
        config.stderr = stderr
      end

      expect(described_class.configuration.stderr).to eq(stderr)
    end

    it 'uses empty string for stdin by default' do
      expect(described_class.configuration.stdin).to eq('')
    end

    it 'allows stdin stream to be overridden' do
      stdin = StringIO.new("some\nuser\ninput\n")

      described_class.configure do |config|
        config.stdin = stdin
      end

      expect(described_class.configuration.stdin).to eq(stdin)
    end
  end

  describe 'terraform commands' do
    commands.each do |method, command_class|
      describe ".#{method}" do
        let(:options) { { user: 'options' } }
        let(:instance) { instance_double(command_class, execute: nil) }

        before do
          allow(Open4).to receive(:spawn)
          allow(command_class).to receive(:new).and_return(instance)
          described_class.send(method, options)
        end

        it "creates an instance of the #{command_class} class and calls " \
           'its execute method' do
          expect(instance).to have_received(:execute).with(options)
        end
      end
    end

    describe '.workspace (old workspace command support)' do
      {
        workspace: RubyTerraform::Commands::WorkspaceList,
        list: RubyTerraform::Commands::WorkspaceList,
        select: RubyTerraform::Commands::WorkspaceSelect,
        new: RubyTerraform::Commands::WorkspaceNew,
        delete: RubyTerraform::Commands::WorkspaceDelete,
        show: RubyTerraform::Commands::WorkspaceShow
      }.each do |subcommand, command_class|
        if subcommand.eql?(:workspace)
          operation = nil
          description = 'when the workspace operation is nil'
        else
          operation = subcommand.to_s
          description = "when the workspace operation is #{operation}"
        end

        describe description do
          let(:options) { { operation: operation } }
          let(:instance) { instance_double(command_class, execute: nil) }

          before do
            allow(Open4).to receive(:spawn)
            allow(command_class).to receive(:new).and_return(instance)
            described_class.send(:workspace, options)
          end

          it "creates an instance of the #{command_class} class and calls " \
             'its execute method' do
            expect(instance).to have_received(:execute).with(options)
          end
        end

        describe 'when an unknown operation is provided' do
          let(:options) { { operation: 'unknown' } }

          it 'raises an error including the invalid operation' do
            expect { described_class.send(:workspace, options) }
              .to raise_error(
                StandardError,
                "Invalid operation 'unknown' supplied to workspace"
              )
          end
        end
      end
    end
  end

  describe 'when included in a class' do
    commands.each_key do |method|
      it "exposes #{method} as a class method on the class" do
        expect(RTIncluded).to respond_to(method)
      end
    end
  end
end
