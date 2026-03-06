# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Plan do
  let(:executor) { Lino::Executors::Mock.new }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
      config.logger = Logger.new(StringIO.new)
    end
    Lino.configure do |config|
      config.executor = executor
    end
  end

  after do
    RubyTerraform.reset!
    Lino.reset!
  end

  it 'logs the command being executed at debug level using the globally ' \
     'configured logger by default' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::DEBUG

    RubyTerraform.configure do |config|
      config.logger = logger
    end

    command = described_class.new(binary: 'terraform')

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(string_output.string).to(
      include('DEBUG').and(
        include(
          "Running 'terraform plan some/path/to/terraform/configuration'."
        )
      )
    )
  end

  it 'logs the command being executed at debug level using the ' \
     'provided logger' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::DEBUG

    command = described_class.new(
      binary: 'terraform',
      logger:
    )

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(string_output.string).to(
      include('DEBUG').and(
        include(
          "Running 'terraform plan some/path/to/terraform/configuration'."
        )
      )
    )
  end

  it 'logs an error raised when running the command' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    RubyTerraform.configure do |config|
      config.logger = logger
    end

    executor.exit_code = 2

    command = described_class.new

    begin
      command.execute(directory: 'some/path/to/terraform/configuration')
    rescue StandardError
      # no-op
    end

    expect(string_output.string).to(
      include('ERROR').and(
        include("Failed while running 'plan'.")
      )
    )
  end

  it 'raises execution error when an error occurs running the command' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    RubyTerraform.configure do |config|
      config.logger = logger
    end

    executor.exit_code = 2

    command = described_class.new

    expect do
      command.execute(directory: 'some/path/to/terraform/configuration')
    end.to(raise_error(RubyTerraform::Errors::ExecutionError))
  end

  it_behaves_like(
    'a command with an argument',
    described_class, 'plan', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'plan'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'plan', :compact_warnings
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'plan', :destroy
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'plan', :detailed_exitcode
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'plan', :input
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'plan', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'plan', :lock_timeout
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'plan', :no_color
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'plan', :plan, name_override: '-out'
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'plan', :parallelism
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'plan', :refresh
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'plan', :refresh_only
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'plan', :state
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'plan', :targets
  )

  it_behaves_like(
    'a command that accepts vars',
    described_class, 'plan'
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'plan', :var_files
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'plan'
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'plan', :replaces
  )
end
