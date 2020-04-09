require 'spec_helper'

describe RubyTerraform::Commands::Validate do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform validate command passing the supplied directory' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform validate some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Validate.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary validate some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'adds a var option for each supplied var' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform validate -var 'first=1' -var 'second=two' some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        vars: {
            first: 1,
            second: 'two'
        })
  end

  it 'correctly serialises list/tuple vars' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform validate -var 'list=[1,\"two\",3]' some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        vars: {
            list: [1, "two", 3]
        })
  end

  it 'correctly serialises map/object vars' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform validate -var 'map={\"first\":1,\"second\":\"two\"}' some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        vars: {
            map: {
                first: 1,
                second: "two"
            }
        })
  end

  it 'correctly serialises vars with lists/tuples of maps/objects' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform validate -var 'list_of_maps=[{\"key\":\"value\"},{\"key\":\"value\"}]' some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        vars: {
            list_of_maps: [
                {key: "value"},
                {key: "value"}
            ]
        })
  end

  it 'adds a state option if a state path is provided' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform validate -state=some/state.tfstate some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        state: 'some/state.tfstate')
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform validate -no-color some/path/to/terraform/configuration', any_args))

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        no_color: true)
  end

  it 'passes check-variables as false when specified' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform validate -check-variables=false some/path/to/terraform/configuration', any_args))

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        check_variables: false)
  end

  it 'adds a var-file option for each element of var-files array' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform validate -var-file=some/vars1.tfvars -var-file=some/vars2.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_files: [
            'some/vars1.tfvars',
            'some/vars2.tfvars'
        ])
  end

  it 'ensures that var_file and var_files options work together' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform validate -var-file=some/vars.tfvars -var-file=some/vars1.tfvars -var-file=some/vars2.tfvars some/configuration", any_args))

    command.execute(
        directory: 'some/configuration',
        var_file: 'some/vars.tfvars',
        var_files: [
            'some/vars1.tfvars',
            'some/vars2.tfvars'
        ])
  end

  it 'includes the json flag when the json option is true' do
    command = RubyTerraform::Commands::Validate.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
        .with('terraform validate -json some/configuration', any_args))

    command.execute(
      directory: 'some/configuration',
      json: true
    )
  end
end
