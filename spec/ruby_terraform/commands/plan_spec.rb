# frozen_string_literal: true

require 'spec_helper'
require 'English'

describe RubyTerraform::Commands::Plan do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
      config.logger = Logger.new(StringIO.new)
    end
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform plan command passing the supplied directory' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with('terraform plan some/path/to/terraform/configuration', any_args)
    )
  end

  it 'defaults to the configured binary when none provided' do
    allow(Open4).to receive(:spawn)
    command = described_class.new

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'path/to/binary plan some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'logs the command being executed at debug level using ' \
     'the globally configured logger by default' do
    allow(Open4).to receive(:spawn)
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

  it 'logs the command being executed at debug level ' \
     'using the provided logger' do
    allow(Open4).to receive(:spawn)
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::DEBUG

    stub_open4_spawn

    command = described_class.new(
      binary: 'terraform', logger: logger
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

  it 'adds a var option for each supplied var' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      vars:      {
        first:  1,
        second: 'two'
      }
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          "terraform plan -var 'first=1' -var 'second=two' some/configuration",
          any_args
        )
    )
  end

  it 'correctly serialises list/tuple vars' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      vars:      {
        list: [1, 'two', 3]
      }
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          "terraform plan -var 'list=[1,\"two\",3]' some/configuration",
          any_args
        )
    )
  end

  it 'correctly serialises map/object vars' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = "terraform plan -var 'map={\"first\":1,\"second\":\"two\"}' " \
              'some/configuration'

    command.execute(
      directory: 'some/configuration',
      vars:      {
        map: {
          first:  1,
          second: 'two'
        }
      }
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'correctly serialises vars with lists/tuples of maps/objects' do
    command = described_class.new(binary: 'terraform')
    message = "terraform plan -var 'list_of_maps=[{\"key\":\"value\"}," \
              "{\"key\":\"value\"}]' some/configuration"
    allow(Open4).to receive(:spawn)

    command.execute(
      directory: 'some/configuration',
      vars:      {
        list_of_maps: [
          { key: 'value' },
          { key: 'value' }
        ]
      }
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'adds a state option if a state path is provided' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      state:     'some/state.tfstate'
    )
    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform plan -state=some/state.tfstate some/configuration',
          any_args
        )
    )
  end

  it 'adds an out option if a plan path is provided' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      plan:      'some/plan.tfplan'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform plan -out=some/plan.tfplan some/configuration',
          any_args
        )
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      no_color:  true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform plan -no-color some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'includes the destroy flag when the destroy option is true' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      destroy:   true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform plan -destroy some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'adds a var-file option if a var file is provided' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      var_file:  'some/vars.tfvars'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform plan -var-file=some/vars.tfvars some/configuration',
          any_args
        )
    )
  end

  it 'adds a var-file option for each element of var-files array' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = 'terraform plan -var-file=some/vars1.tfvars ' \
              '-var-file=some/vars2.tfvars some/configuration'
    command.execute(
      directory: 'some/configuration',
      var_files: [
        'some/vars1.tfvars',
        'some/vars2.tfvars'
      ]
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'ensures that var_file and var_files options work together' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = 'terraform plan -var-file=some/vars.tfvars ' \
              '-var-file=some/vars1.tfvars ' \
              '-var-file=some/vars2.tfvars some/configuration'

    command.execute(
      directory: 'some/configuration',
      var_file:  'some/vars.tfvars',
      var_files: [
        'some/vars1.tfvars',
        'some/vars2.tfvars'
      ]
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'adds a input option if a input value is provided' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      input:     'false'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with('terraform plan -input=false some/configuration', any_args)
    )
  end

  it 'adds a target option if a target is provided' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      target:    'some_resource_name'
    )

    expect(Open4).to(
      have_received(:spawn)
      .with(
        'terraform plan -target=some_resource_name some/configuration',
        any_args
      )
    )
  end

  it 'adds a target option for each element of target array' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = 'terraform plan -target=some_resource_1 ' \
              '-target=some_resource_2 ' \
              'some/configuration'

    command.execute(
      directory: 'some/configuration',
      targets:   [
        'some_resource_1',
        'some_resource_2'
      ]
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'ensures that target and targets options work together' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = 'terraform plan -target=some_resource_1 ' \
              '-target=some_resource_2 ' \
              '-target=some_resource_3 some/configuration'

    command.execute(
      directory: 'some/configuration',
      target:    'some_resource_1',
      targets:   [
        'some_resource_2',
        'some_resource_3'
      ]
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
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
      nil
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

    directory = 'some/path/to/terraform/configuration'
    expect { command.execute(directory: directory) }
      .to(raise_error(RubyTerraform::Errors::ExecutionError))
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
end
