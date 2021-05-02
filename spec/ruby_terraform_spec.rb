# frozen_string_literal: true

require 'spec_helper'

class RTIncluded
  include RubyTerraform
end

describe RubyTerraform do
  commands = {
    apply: RubyTerraform::Commands::Apply,
    destroy: RubyTerraform::Commands::Destroy,
    force_unlock: RubyTerraform::Commands::ForceUnlock,
    format: RubyTerraform::Commands::Format,
    get: RubyTerraform::Commands::Get,
    graph: RubyTerraform::Commands::Graph,
    import: RubyTerraform::Commands::Import,
    init: RubyTerraform::Commands::Init,
    login: RubyTerraform::Commands::Login,
    logout: RubyTerraform::Commands::Logout,
    output: RubyTerraform::Commands::Output,
    plan: RubyTerraform::Commands::Plan,
    providers: RubyTerraform::Commands::Providers,
    providers_lock: RubyTerraform::Commands::ProvidersLock,
    providers_mirror: RubyTerraform::Commands::ProvidersMirror,
    providers_schema: RubyTerraform::Commands::ProvidersSchema,
    refresh: RubyTerraform::Commands::Refresh,
    show: RubyTerraform::Commands::Show,
    state_list: RubyTerraform::Commands::StateList,
    state_mv: RubyTerraform::Commands::StateMove,
    state_pull: RubyTerraform::Commands::StatePull,
    state_push: RubyTerraform::Commands::StatePush,
    state_replace_provider: RubyTerraform::Commands::StateReplaceProvider,
    state_rm: RubyTerraform::Commands::StateRemove,
    state_show: RubyTerraform::Commands::StateShow,
    taint: RubyTerraform::Commands::Taint,
    untaint: RubyTerraform::Commands::Untaint,
    validate: RubyTerraform::Commands::Validate,
    workspace_delete: RubyTerraform::Commands::WorkspaceDelete,
    workspace_list: RubyTerraform::Commands::WorkspaceList,
    workspace_new: RubyTerraform::Commands::WorkspaceNew,
    workspace_select: RubyTerraform::Commands::WorkspaceSelect,
    workspace_show: RubyTerraform::Commands::WorkspaceShow
  }

  it 'has a version number' do
    expect(RubyTerraform::VERSION).not_to be nil
  end

  it 'allows commands to be run without configure having been called' do
    allow(Open4).to(receive(:spawn))

    described_class.apply(directory: 'some/path/to/terraform/configuration')
  end

  describe 'configuration' do
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
      string_io = StringIO.new
      logger = Logger.new(string_io)
      logger.level = Logger::DEBUG

      described_class.configure do |config|
        config.logger = logger
      end

      described_class
        .configuration
        .logger
        .debug('Logging with a custom logger at debug level.')

      expect(string_io.string)
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

  # rubocop:disable RSpec/NestedGroups
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
        operation = subcommand.eql?(:workspace) ? nil : subcommand.to_s

        describe "when the workspace operation is #{operation}" do
          let(:options) { { operation: operation } }
          let(:instance) { instance_double(command_class, execute: nil) }

          before do
            allow(Open4).to receive(:spawn)
            allow(command_class).to receive(:new).and_return(instance)
            described_class.send(:workspace, options)
          end

          it "creates an instance of the #{command_class} class and calls " \
             'its execute method' do
            expect(instance)
              .to(have_received(:execute).with(options))
          end
        end
      end

      describe 'when an unknown operation is provided' do
        let(:options) { { operation: 'unknown' } }

        it 'raises an error including the invalid operation' do
          expect { described_class.send(:workspace, options) }
            .to(raise_error(
                  StandardError,
                  "Invalid operation 'unknown' supplied to workspace"
                ))
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe 'when included in a class' do
    commands.each_key do |method|
      it "exposes #{method} as a class method on the class" do
        expect(RTIncluded).to respond_to(method)
      end
    end
  end
end
