require 'spec_helper'
require_relative '../lib/ruby_terraform/commands'

class RTIncluded
  include RubyTerraform
end

describe RubyTerraform do
  terraform_commands = {
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
    workspace: RubyTerraform::Commands::Workspace
  }

  it 'has a version number' do
    expect(RubyTerraform::VERSION).not_to be nil
  end

  it 'allows commands to be run without configure having been called' do
    allow(Open4).to(receive(:spawn))

    RubyTerraform.apply(directory: 'some/path/to/terraform/configuration')
  end

  context 'configuration' do
    before(:each) do
      RubyTerraform.reset!
    end

    it 'logs to standard output by default' do
      expect do
        RubyTerraform.configuration
                     .logger
                     .info('Logging with the default logger.')
      end.to output(/Logging with the default logger./).to_stdout
    end

    it 'has info log level by default' do
      expect(RubyTerraform.configuration.logger.level).to eq(Logger::INFO)
    end

    it 'allows default logger to be overridden' do
      string_output = StringIO.new
      logger = Logger.new(string_output)
      logger.level = Logger::DEBUG

      RubyTerraform.configure do |config|
        config.logger = logger
      end

      RubyTerraform.configuration.logger
                   .debug('Logging with a custom logger at debug level.')

      expect(string_output.string)
        .to include('Logging with a custom logger at debug level.')
    end

    it 'has bare terraform command as default binary' do
      expect(RubyTerraform.configuration.binary).to eq('terraform')
    end

    it 'allows binary to be overridden' do
      RubyTerraform.configure do |config|
        config.binary = '/path/to/terraform'
      end
      expect(RubyTerraform.configuration.binary).to eq('/path/to/terraform')
    end

    it 'uses whatever $stdout points to for stdout by default' do
      expect(RubyTerraform.configuration.stdout).to eq($stdout)
    end

    it 'allows stdout stream to be overridden' do
      stdout = StringIO.new

      RubyTerraform.configure do |config|
        config.stdout = stdout
      end

      expect(RubyTerraform.configuration.stdout).to eq(stdout)
    end

    it 'uses whatever $stderr points to for stderr by default' do
      expect(RubyTerraform.configuration.stderr).to eq($stderr)
    end

    it 'allows stderr stream to be overridden' do
      stderr = StringIO.new

      RubyTerraform.configure do |config|
        config.stderr = stderr
      end

      expect(RubyTerraform.configuration.stderr).to eq(stderr)
    end

    it 'uses empty string for stdin by default' do
      expect(RubyTerraform.configuration.stdin).to eq('')
    end

    it 'allows stdin stream to be overridden' do
      stdin = StringIO.new("some\nuser\ninput\n")

      RubyTerraform.configure do |config|
        config.stdin = stdin
      end

      expect(RubyTerraform.configuration.stdin).to eq(stdin)
    end
  end

  describe 'terraform commands' do
    terraform_commands.each do |method, command_class|
      describe ".#{method}" do
        let(:options) { { user: 'options' } }
        let(:instance) { instance_double(command_class, execute: nil) }

        before do
          allow(command_class).to receive(:new).and_return(instance)
          described_class.send(method, options)
        end

        it "creates an instance of the #{command_class} class and calls its execute method" do
          expect(instance).to have_received(:execute).with(options)
        end
      end
    end
  end

  describe 'when included in a class' do
    terraform_commands.each_key do |method|
      it "exposes #{method} as a class method on the class" do
        expect(RTIncluded).to respond_to(method)
      end
    end
  end
end
