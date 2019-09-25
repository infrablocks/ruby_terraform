require 'spec_helper'

describe RubyTerraform::Configuration do
  after(:each) do
    RubyTerraform.reset!
  end

  it 'logs to standard output by default' do
    $stdout = StringIO.new

    RubyTerraform.configuration.logger
        .info("Logging with the default logger.")

    expect($stdout.string).to include("Logging with the default logger.")
  end

  it 'has info log level by default' do
    $stdout = StringIO.new

    RubyTerraform.configuration.logger
        .debug("Logging with the default logger at debug level.")

    expect($stdout.string).to eq("")

    RubyTerraform.configuration.logger
        .info("Logging with the default logger at info level.")

    expect($stdout.string)
        .to include("Logging with the default logger at info level.")
  end

  it 'allows default logger to be overridden' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::DEBUG

    RubyTerraform.configure do |config|
      config.logger = logger
    end

    RubyTerraform.configuration.logger
      .debug("Logging with a custom logger at debug level.")

    expect(string_output.string)
        .to include("Logging with a custom logger at debug level.")
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

  it 'uses whatever $stdin points to for stdin by default' do
    expect(RubyTerraform.configuration.stdin).to eq($stdin)
  end

  it 'allows stdin stream to be overridden' do
    stdin = StringIO.new("some\nuser\ninput\n")

    RubyTerraform.configure do |config|
      config.stdin = stdin
    end

    expect(RubyTerraform.configuration.stdin).to eq(stdin)
  end
end
