# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Import do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform import command passing the supplied directory' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
        .with('terraform import -config=some/path/to/terraform/configuration a.resource.address a-resource-id', any_args)
    )

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id'
    )
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Import.new

    expect(Open4).to(
      receive(:spawn)
          .with('path/to/binary import -config=some/path/to/terraform/configuration a.resource.address-2 a-resource-id.3', any_args)
    )

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      address: 'a.resource.address-2',
      id: 'a-resource-id.3'
    )
  end

  it 'adds a var option for each supplied var' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
        .with("terraform import -config=some/configuration -var 'first=1' -var 'second=two' a.resource.address a-resource-id", any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      vars: {
        first: 1,
        second: 'two'
      }
    )
  end

  it 'correctly serialises list/tuple vars' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with("terraform import -config=some/configuration -var 'list=[1,\"two\",3]' a.resource.address a-resource-id", any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      vars: {
        list: [1, 'two', 3]
      }
    )
  end

  it 'correctly serialises map/object vars' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with("terraform import -config=some/configuration -var 'map={\"first\":1,\"second\":\"two\"}' a.resource.address a-resource-id", any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      vars: {
        map: {
          first: 1,
          second: 'two'
        }
      }
    )
  end

  it 'correctly serialises vars with lists/tuples of maps/objects' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with("terraform import -config=some/configuration -var 'list_of_maps=[{\"key\":\"value\"},{\"key\":\"value\"}]' a.resource.address a-resource-id", any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      vars: {
        list_of_maps: [
          { key: 'value' },
          { key: 'value' }
        ]
      }
    )
  end

  it 'adds a state option if a state path is provided' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with('terraform import -config=some/configuration -state=some/state.tfstate a.resource.address a-resource-id', any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      state: 'some/state.tfstate'
    )
  end

  it 'adds a backup option if a backup path is provided' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with('terraform import -config=some/configuration -backup=some/state.tfstate.backup a.resource.address a-resource-id', any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      backup: 'some/state.tfstate.backup'
    )
  end

  it 'disables backup if no_backup is true' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with('terraform import -config=some/configuration -backup=- a.resource.address a-resource-id', any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      backup: 'some/state.tfstate.backup',
      no_backup: true
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with('terraform import -config=some/path/to/terraform/configuration -no-color a.resource.address a-resource-id', any_args)
    )

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      no_color: true
    )
  end

  it 'adds a var-file option if a var file is provided' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with('terraform import -config=some/configuration -var-file=some/vars.tfvars a.resource.address a-resource-id', any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      var_file: 'some/vars.tfvars'
    )
  end

  it 'adds a var-file option for each element of var-files array' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with('terraform import -config=some/configuration -var-file=some/vars1.tfvars -var-file=some/vars2.tfvars a.resource.address a-resource-id', any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      var_files: [
        'some/vars1.tfvars',
        'some/vars2.tfvars'
      ]
    )
  end

  it 'ensures that var_file and var_files options work together' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with('terraform import -config=some/configuration -var-file=some/vars.tfvars -var-file=some/vars1.tfvars -var-file=some/vars2.tfvars a.resource.address a-resource-id', any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      var_file: 'some/vars.tfvars',
      var_files: [
        'some/vars1.tfvars',
        'some/vars2.tfvars'
      ]
    )
  end

  it 'adds a input option if a input value is provided' do
    command = RubyTerraform::Commands::Import.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with('terraform import -config=some/configuration -input=false a.resource.address a-resource-id', any_args)
    )

    command.execute(
      directory: 'some/configuration',
      address: 'a.resource.address',
      id: 'a-resource-id',
      input: 'false'
    )
  end
end
