require 'spec_helper'
require 'logger'

describe RubyTerraform::Commands::Clean do
  before(:each) do
    RubyTerraform.configure do |config|
      config.logger = Logger.new(StringIO.new)
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'deletes the .terraform directory in the current directory by default' do
    command = RubyTerraform::Commands::Clean.new

    expect(FileUtils).to(
        receive(:rm_r).with('.terraform', :secure => true))

    command.execute
  end

  it 'logs to the provided logger at info level when deleting .terraform directory' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    stub_fileutils_rm_r

    command = RubyTerraform::Commands::Clean.new(logger: logger)
    command.execute

    expect(string_output.string).to(
        include('INFO').and(
            include("Cleaning terraform directory '.terraform'.")))
  end

  it 'logs to the globally configured logger by default' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    RubyTerraform.configure do |config|
      config.logger = logger
    end

    stub_fileutils_rm_r

    command = RubyTerraform::Commands::Clean.new
    command.execute

    expect(string_output.string).to(
        include('INFO').and(
            include("Cleaning terraform directory '.terraform'.")))
  end

  it 'deletes the provided directory when specified' do
    command = RubyTerraform::Commands::Clean.new(directory: 'some/path')

    expect(FileUtils).to(
        receive(:rm_r).with('some/path', :secure => true))

    command.execute
  end

  it 'logs to the provided logger at info level when deleting provided directory' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    stub_fileutils_rm_r

    command = RubyTerraform::Commands::Clean.new(
        directory: 'some/path', logger: logger)
    command.execute

    expect(string_output.string).to(
        include('INFO').and(
            include("Cleaning terraform directory 'some/path'.")))
  end

  it 'allows the directory to be overridden on execution' do
    command = RubyTerraform::Commands::Clean.new

    expect(FileUtils).to(
        receive(:rm_r).with('some/.terraform', :secure => true))
    command.execute(directory: 'some/.terraform')
  end

  it 'logs to the provided logger at info level when deleting overridden directory' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    stub_fileutils_rm_r

    command = RubyTerraform::Commands::Clean.new(logger: logger)
    command.execute(directory: 'some/.terraform')

    expect(string_output.string).to(
        include('INFO').and(
            include("Cleaning terraform directory 'some/.terraform'.")))
  end

  it 'logs an exception when no terraform directory is found' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    stub_fileutils_rm_r_raise

    command = RubyTerraform::Commands::Clean.new(logger: logger)
    command.execute(directory: '/this/path/does/not/exist')

    expect(string_output.string).to(
      include('INFO').and(
        include("Cleaning terraform directory '/this/path/does/not/exist'")
      )
    )
    expect(string_output.string).to(
      include('ERROR').and(
        include("Couldn't clean '/this/path/does/not/exist'")
      )
    )
  end

  def stub_fileutils_rm_r
    allow(FileUtils).to(receive(:rm_r))
  end

  def stub_fileutils_rm_r_raise
    allow(FileUtils).to(receive(:rm_r).and_raise Errno::ENOENT)
  end
end
