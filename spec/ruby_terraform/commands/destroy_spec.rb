require 'spec_helper'

describe RubyTerraform::Commands::Destroy do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform destroy command passing the supplied directory' do
    command = RubyTerraform::Commands::Destroy.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform destroy some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Destroy.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary destroy some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'adds a var option for each supplied var' do
    command = RubyTerraform::Commands::Destroy.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform destroy -var 'first=1' -var 'second=two' some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        vars: {
            first: 1,
            second: 'two'
        })
  end

  it 'adds a state option if a state path is provided' do
    command = RubyTerraform::Commands::Destroy.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform destroy -state=some/state.tfstate some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        state: 'some/state.tfstate')
  end

  it 'adds a backup option if a backup path is provided' do
    command = RubyTerraform::Commands::Destroy.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform destroy -backup=some/state.tfstate.backup some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        backup: 'some/state.tfstate.backup')
  end

  it 'disables backup if no_backup is true' do
    command = RubyTerraform::Commands::Destroy.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform destroy -backup=- some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        backup: 'some/state.tfstate.backup',
        no_backup: true)
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Destroy.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform destroy -no-color some/path/to/terraform/configuration', any_args))

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        no_color: true)
  end

  it 'forces the destroy when the force option is true' do
    command = RubyTerraform::Commands::Destroy.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform destroy -force some/path/to/terraform/configuration', any_args))

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        force: true)
  end

  it 'adds a var-file option if a var file is provided' do
    command = RubyTerraform::Commands::Destroy.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform destroy -var-file=some/vars.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_file: 'some/vars.tfvars')
  end

  it 'adds a var-file option for each element of var-files array' do
    command = RubyTerraform::Commands::Destroy.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform destroy -var-file=some/vars1.tfvars -var-file=some/vars2.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_files: [ 
            'some/vars1.tfvars',
            'some/vars2.tfvars'
        ])
  end

  it 'ensures that var_file and var_files options work together' do
    command = RubyTerraform::Commands::Destroy.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform destroy -var-file=some/vars.tfvars -var-file=some/vars1.tfvars -var-file=some/vars2.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_file: 'some/vars.tfvars',
        var_files: [ 
            'some/vars1.tfvars',
            'some/vars2.tfvars'
        ])
  end
end
