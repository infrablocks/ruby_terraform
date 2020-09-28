# frozen_string_literal: true

require 'spec_helper'
require 'logger'

describe RubyTerraform::Commands::Clean do
  before do
    RubyTerraform.configure do |config|
      config.logger = Logger.new(StringIO.new)
    end
    stub_fileutils_rm_r
  end

  after do
    RubyTerraform.reset!
  end

  it 'deletes the .terraform directory in the current directory by default' do
    command = described_class.new

    command.execute

    expect(FileUtils).to(
      have_received(:rm_r).with('.terraform', secure: true)
    )
  end

  it 'logs to the provided logger at info level ' \
     'when deleting .terraform directory' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    stub_fileutils_rm_r

    command = described_class.new(logger: logger)
    command.execute

    expect(string_output.string).to(
      include('INFO').and(
        include("Cleaning terraform directory '.terraform'.")
      )
    )
  end

  it 'logs to the globally configured logger by default' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    RubyTerraform.configure do |config|
      config.logger = logger
    end

    stub_fileutils_rm_r

    command = described_class.new
    command.execute

    expect(string_output.string).to(
      include('INFO').and(
        include("Cleaning terraform directory '.terraform'.")
      )
    )
  end

  it 'deletes the provided directory when specified' do
    command = described_class.new(directory: 'some/path')

    command.execute

    expect(FileUtils).to(
      have_received(:rm_r).with('some/path', secure: true)
    )
  end

  it 'logs to the provided logger at info level ' \
     'when deleting provided directory' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    command = described_class.new(
      directory: 'some/path', logger: logger
    )
    command.execute

    expect(string_output.string).to(
      include('INFO').and(
        include("Cleaning terraform directory 'some/path'.")
      )
    )
  end

  it 'allows the directory to be overridden on execution' do
    command = described_class.new

    command.execute(directory: 'some/.terraform')

    expect(FileUtils).to(
      have_received(:rm_r).with('some/.terraform', secure: true)
    )
  end

  it 'logs to the provided logger at info level ' \
     'when deleting overridden directory' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    stub_fileutils_rm_r

    command = described_class.new(logger: logger)
    command.execute(directory: 'some/.terraform')

    expect(string_output.string).to(
      include('INFO').and(
        include("Cleaning terraform directory 'some/.terraform'.")
      )
    )
  end

  it 'logs an exception when no terraform directory is found' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    stub_fileutils_rm_r_raise

    command = described_class.new(logger: logger)
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
    allow(FileUtils).to(receive(:rm_r).and_raise(Errno::ENOENT))
  end
end
