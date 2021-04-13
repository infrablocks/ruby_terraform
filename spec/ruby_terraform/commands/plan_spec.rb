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

  command = 'plan'
  directory = Faker::File.dir

  # it 'logs the command being executed at debug level using the globally ' \
  #    'configured logger by default' do
  #   string_output = StringIO.new
  #   logger = Logger.new(string_output)
  #   logger.level = Logger::DEBUG
  #
  #   RubyTerraform.configure do |config|
  #     config.logger = logger
  #   end
  #
  #   stub_open4_spawn
  #
  #   command = described_class.new(binary: 'terraform')
  #
  #   command.execute(directory: 'some/path/to/terraform/configuration')
  #
  #   expect(string_output.string).to(
  #     include('DEBUG').and(
  #       include(
  #         "Running 'terraform plan some/path/to/terraform/configuration'."
  #       )
  #     )
  #   )
  # end
  #
  # it 'logs the command being executed at debug level using the ' \
  #    'provided logger' do
  #   string_output = StringIO.new
  #   logger = Logger.new(string_output)
  #   logger.level = Logger::DEBUG
  #
  #   stub_open4_spawn
  #
  #   command = described_class.new(
  #     binary: 'terraform',
  #     logger: logger
  #   )
  #
  #   command.execute(directory: 'some/path/to/terraform/configuration')
  #
  #   expect(string_output.string).to(
  #     include('DEBUG').and(
  #       include(
  #         "Running 'terraform plan some/path/to/terraform/configuration'."
  #       )
  #     )
  #   )
  # end
  #
  # it 'logs an error raised when running the command' do
  #   string_output = StringIO.new
  #   logger = Logger.new(string_output)
  #   logger.level = Logger::INFO
  #
  #   RubyTerraform.configure do |config|
  #     config.logger = logger
  #   end
  #
  #   stub_open4_spawn_raise
  #   command = described_class.new
  #
  #   begin
  #     command.execute(directory: 'some/path/to/terraform/configuration')
  #   rescue StandardError
  #     # no-op
  #   end
  #
  #   expect(string_output.string).to(
  #     include('ERROR').and(
  #       include("Failed while running 'plan'.")
  #     )
  #   )
  # end
  #
  # it 'raises execution error when an error occurs running the command' do
  #   string_output = StringIO.new
  #   logger = Logger.new(string_output)
  #   logger.level = Logger::INFO
  #
  #   RubyTerraform.configure do |config|
  #     config.logger = logger
  #   end
  #
  #   stub_open4_spawn_raise
  #   command = described_class.new
  #
  #   expect do
  #     command.execute(directory: 'some/path/to/terraform/configuration')
  #   end.to(raise_error(RubyTerraform::Errors::ExecutionError))
  # end
  #
  # def stub_open4_spawn
  #   allow(Open4).to(receive(:spawn))
  # end
  #
  # def stub_open4_spawn_raise
  #   allow_any_instance_of(Process::Status).to(
  #     receive(:exitstatus).and_return(0)
  #   )
  #   allow(Open4).to(
  #     receive(:spawn)
  #       .and_raise(Open4::SpawnError.new('cmd', $CHILD_STATUS), 'message')
  #   )
  # end
  #
  # it_behaves_like(
  #   'a command with an argument', [command, :directory]
  # )
  #
  # it_behaves_like(
  #   'a command without a binary supplied',
  #   [command, described_class, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with a flag',
  #   [command, :compact_warnings, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with a flag',
  #   [command, :destroy, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with a flag',
  #   [command, :detailed_exitcode, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with a boolean option',
  #   [command, :input, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with a boolean option',
  #   [command, :lock, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with an option',
  #   [command, :lock_timeout, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with a flag',
  #   [command, :no_color, directory]
  # )

  it_behaves_like(
    'a command with an option',
    [command, :plan, directory,
     { name_override: '-out' }]
  )

  # it_behaves_like(
  #   'a command with an option',
  #   [command, :parallelism, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with a boolean option',
  #   [command, :refresh, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with an option',
  #   [command, :state, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with an array option',
  #   [command, :targets, directory]
  # )
  #
  # it_behaves_like(
  #   'a command that accepts vars', [command, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with an array option',
  #   [command, :var_files, directory]
  # )
  #
  # it_behaves_like(
  #   'a command with common options',
  #   [command, directory]
  # )
end
