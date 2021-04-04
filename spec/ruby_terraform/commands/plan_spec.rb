# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Plan do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
      config.logger = Logger.new(StringIO.new)
    end
  end

  after do
    RubyTerraform.reset!
  end

  terraform_command = 'plan'
  terraform_config_path = Faker::File.dir

  it 'logs the command being executed at debug level using the globally ' \
     'configured logger by default' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::DEBUG

    RubyTerraform.configure do |config|
      config.logger = logger
    end

    stub_open4_spawn

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

    stub_open4_spawn

    command = described_class.new(
      binary: 'terraform',
      logger: logger
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

    stub_open4_spawn_raise
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

    stub_open4_spawn_raise
    command = described_class.new

    expect do
      command.execute(directory: 'some/path/to/terraform/configuration')
    end.to(raise_error(RubyTerraform::Errors::ExecutionError))
  end

  def stub_open4_spawn
    allow(Open4).to(receive(:spawn))
  end

  def stub_open4_spawn_raise
    allow_any_instance_of(Process::Status).to(
      receive(:exitstatus).and_return(0)
    )
    allow(Open4).to(
      receive(:spawn)
        .and_raise(Open4::SpawnError.new('cmd', $CHILD_STATUS), 'message')
    )
  end

  it_behaves_like(
    'a command with an argument', [terraform_command, :directory]
  )

  it_behaves_like(
    'a command without a binary supplied',
    [terraform_command, described_class, terraform_config_path]
  )

  it_behaves_like(
    'a command with a flag',
    [terraform_command, :compact_warnings, terraform_config_path]
  )

  it_behaves_like(
    'a command with a flag',
    [terraform_command, :destroy, terraform_config_path]
  )

  it_behaves_like(
    'a command with a flag',
    [terraform_command, :detailed_exitcode, terraform_config_path]
  )

  it_behaves_like(
    'a command with a boolean option',
    [terraform_command, :input, terraform_config_path]
  )

  it_behaves_like(
    'a command with a boolean option',
    [terraform_command, :lock, terraform_config_path]
  )

  it_behaves_like(
    'a command with an option',
    [terraform_command, :lock_timeout, terraform_config_path]
  )

  it_behaves_like(
    'a command with a flag',
    [terraform_command, :no_color, terraform_config_path]
  )

  it_behaves_like(
    'a command with an option',
    [terraform_command, :plan, terraform_config_path,
     { name_override: '-out' }]
  )

  it_behaves_like(
    'a command with an option',
    [terraform_command, :parallelism, terraform_config_path]
  )

  it_behaves_like(
    'a command with a boolean option',
    [terraform_command, :refresh, terraform_config_path]
  )

  it_behaves_like(
    'a command with an option',
    [terraform_command, :state, terraform_config_path]
  )

  it_behaves_like(
    'a command with an array option',
    [terraform_command, :targets, terraform_config_path]
  )

  it_behaves_like(
    'a command that accepts vars', [terraform_command, terraform_config_path]
  )

  it_behaves_like(
    'a command with an array option',
    [terraform_command, :var_files, terraform_config_path]
  )

  it_behaves_like(
    'a command with common options',
    [terraform_command, terraform_config_path]
  )
end
