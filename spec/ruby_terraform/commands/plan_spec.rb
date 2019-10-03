require 'spec_helper'

describe RubyTerraform::Commands::Plan do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
      config.logger = Logger.new(StringIO.new)
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform plan command passing the supplied directory' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform plan some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Plan.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary plan some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'logs the command being executed at debug level using the globally configured logger by default' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::DEBUG

    RubyTerraform.configure do |config|
      config.logger = logger
    end

    stub_open4_spawn

    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(string_output.string).to(
        include('DEBUG').and(
            include("Running 'terraform plan some/path/to/terraform/configuration'.")))
  end

  it 'logs the command being executed at debug level using the provided logger' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::DEBUG

    stub_open4_spawn

    command = RubyTerraform::Commands::Plan.new(
        binary: 'terraform', logger: logger)

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(string_output.string).to(
        include('DEBUG').and(
            include("Running 'terraform plan some/path/to/terraform/configuration'.")))
  end

  it 'adds a var option for each supplied var' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform plan -var 'first=1' -var 'second=two' some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        vars: {
            first: 1,
            second: 'two'
        })
  end

  it 'adds a state option if a state path is provided' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform plan -state=some/state.tfstate some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        state: 'some/state.tfstate')
  end

  it 'adds an out option if a plan path is provided' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform plan -out=some/plan.tfplan some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        plan: 'some/plan.tfplan')
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform plan -no-color some/path/to/terraform/configuration', any_args))

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        no_color: true)
  end

  it 'includes the destroy flag when the destroy option is true' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform plan -destroy some/path/to/terraform/configuration', any_args))

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        destroy: true)
  end

  it 'adds a var-file option if a var file is provided' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform plan -var-file=some/vars.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_file: 'some/vars.tfvars')
  end

  it 'adds a var-file option for each element of var-files array' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform plan -var-file=some/vars1.tfvars -var-file=some/vars2.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_files: [
            'some/vars1.tfvars',
            'some/vars2.tfvars'
        ])
  end

  it 'ensures that var_file and var_files options work together' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform plan -var-file=some/vars.tfvars -var-file=some/vars1.tfvars -var-file=some/vars2.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_file: 'some/vars.tfvars',
        var_files: [
            'some/vars1.tfvars',
            'some/vars2.tfvars'
        ])
  end

  it 'adds a input option if a input value is provided' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform plan -input=false some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        input: 'false')
  end

  it 'adds a target option if a target is provided' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform plan -target=some_resource_name some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        target: 'some_resource_name')
  end

  it 'adds a target option for each element of target array' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform plan -target=some_resource_1 -target=some_resource_2 some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        targets: [
            'some_resource_1',
            'some_resource_2'
        ])
  end

  it 'ensures that target and targets options work together' do
    command = RubyTerraform::Commands::Plan.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform plan -target=some_resource_1 -target=some_resource_2 -target=some_resource_3 some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        target: 'some_resource_1',
        targets: [
            'some_resource_2',
            'some_resource_3'
        ])
  end

  it 'logs an exception raised when running the command' do
    string_output = StringIO.new
    logger = Logger.new(string_output)
    logger.level = Logger::INFO

    RubyTerraform.configure do |config|
      config.logger = logger
    end

    stub_open4_spawn_raise
    command = RubyTerraform::Commands::Plan.new

    command.execute(directory: 'some/path/to/terraform/configuration')

    cmd = 'path/to/binary plan some/path/to/terraform/configuration'
    expect(string_output.string).to(
      include('ERROR').and(
        include("Command '#{cmd}' has failed.")
      )
    )
  end

  def stub_open4_spawn
    allow(Open4).to(receive(:spawn))
  end

  def stub_open4_spawn_raise
    allow_any_instance_of(Process::Status).to receive(:exitstatus).and_return(0)
    allow(Open4).to(
      receive(:spawn)
        .and_raise(Open4::SpawnError.new("cmd", $?), "message")
    )
  end
end
