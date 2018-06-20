require 'spec_helper'

describe RubyTerraform::Commands::Refresh do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform refresh command passing the supplied directory' do
    command = RubyTerraform::Commands::Refresh.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform refresh some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Refresh.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary refresh some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'adds a var option for each supplied var' do
    command = RubyTerraform::Commands::Refresh.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform refresh -var 'first=1' -var 'second=two' some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        vars: {
            first: 1,
            second: 'two'
        })
  end

  it 'adds a state option if a state path is provided' do
    command = RubyTerraform::Commands::Refresh.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform refresh -state=some/state.tfstate some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        state: 'some/state.tfstate')
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Refresh.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform refresh -no-color some/path/to/terraform/configuration', any_args))

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        no_color: true)
  end

  it 'adds a var-file option for each element of var-files array' do
    command = RubyTerraform::Commands::Refresh.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform refresh -var-file=some/vars1.tfvars -var-file=some/vars2.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_files: [ 
            'some/vars1.tfvars',
            'some/vars2.tfvars'
        ])
  end

  it 'ensures that var_file and var_files options work together' do
    command = RubyTerraform::Commands::Refresh.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform refresh -var-file=some/vars.tfvars -var-file=some/vars1.tfvars -var-file=some/vars2.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_file: 'some/vars.tfvars',
        var_files: [ 
            'some/vars1.tfvars',
            'some/vars2.tfvars'
        ])
  end
end
