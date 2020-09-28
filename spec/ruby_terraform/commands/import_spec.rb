# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Import do
  let(:command) { described_class.new(binary: 'terraform') }
  let(:terra_config) { 'terraform import -config=some/configuration ' }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
    allow(Open4).to receive(:spawn)
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform import command passing the supplied directory' do
    message = 'terraform import -config=some/path/to/terraform/configuration ' \
              'a.resource.address a-resource-id'

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new
    message = 'path/to/binary import ' \
              '-config=some/path/to/terraform/configuration ' \
              'a.resource.address-2 a-resource-id.3'

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      address:   'a.resource.address-2',
      id:        'a-resource-id.3'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'adds a var option for each supplied var' do
    message = "terraform import -config=some/configuration -var 'first=1' " \
              "-var 'second=two' a.resource.address a-resource-id"
    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
      vars:      {
        first:  1,
        second: 'two'
      }
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'correctly serialises list/tuple vars' do
    message = terra_config + "-var 'list=[1,\"two\",3]' " \
                             'a.resource.address a-resource-id'

    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
      vars:      {
        list: [1, 'two', 3]
      }
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'correctly serialises map/object vars' do
    message = terra_config + "-var 'map={\"first\":1,\"second\":\"two\"}' " \
                             'a.resource.address a-resource-id'
    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
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
    message = 'terraform import -config=some/configuration -var ' \
              "'list_of_maps=[{\"key\":\"value\"},{\"key\":\"value\"}]' " \
              'a.resource.address a-resource-id'

    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
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
    message = terra_config + '-state=some/state.tfstate a.resource.address ' \
                             'a-resource-id'

    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
      state:     'some/state.tfstate'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'adds a backup option if a backup path is provided' do
    message = terra_config + '-backup=some/state.tfstate.backup ' \
                             'a.resource.address a-resource-id'

    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
      backup:    'some/state.tfstate.backup'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'disables backup if no_backup is true' do
    message = terra_config + '-backup=- a.resource.address a-resource-id'

    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
      backup:    'some/state.tfstate.backup',
      no_backup: true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    message = 'terraform import -config=some/path/to/terraform/configuration ' \
              '-no-color a.resource.address a-resource-id'

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
      no_color:  true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'adds a var-file option if a var file is provided' do
    message = terra_config + '-var-file=some/vars.tfvars ' \
                             'a.resource.address a-resource-id'

    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
      var_file:  'some/vars.tfvars'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'adds a var-file option for each element of var-files array' do
    message = terra_config + '-var-file=some/vars1.tfvars ' \
                             '-var-file=some/vars2.tfvars ' \
                             'a.resource.address a-resource-id'

    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
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
    message = terra_config + '-var-file=some/vars.tfvars ' \
                             '-var-file=some/vars1.tfvars ' \
                             '-var-file=some/vars2.tfvars ' \
                             'a.resource.address a-resource-id'

    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
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
    message = terra_config + '-input=false a.resource.address a-resource-id'

    command.execute(
      directory: 'some/configuration',
      address:   'a.resource.address',
      id:        'a-resource-id',
      input:     'false'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end
end
