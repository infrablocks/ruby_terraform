# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Destroy do
  let(:command) { described_class.new(binary: 'terraform') }
  let(:config_dir) { 'some/configuration' }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
      config.logger = Logger.new(StringIO.new)
    end
    allow(Open4).to receive(:spawn)
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform destroy command passing the supplied directory' do
    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform destroy some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'path/to/binary destroy some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'adds a var option for each supplied var' do
    message = "terraform destroy -var 'first=1' -var 'second=two' " \
              'some/configuration'
    command.execute(
      directory: 'some/configuration',
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
    command.execute(
      directory: 'some/configuration',
      vars:      {
        list: [1, 'two', 3]
      }
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          "terraform destroy -var 'list=[1,\"two\",3]' some/configuration",
          any_args
        )
    )
  end

  it 'correctly serialises map/object vars' do
    message = "terraform destroy -var 'map={\"first\":1,\"second\":\"two\"}' " \
              'some/configuration'
    command.execute(
      directory: config_dir,
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
    message = "terraform destroy -var 'list_of_maps=[{\"key\":\"value\"}," \
              "{\"key\":\"value\"}]' some/configuration"
    command.execute(
      directory: config_dir,
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
    command.execute(
      directory: config_dir,
      state:     'some/state.tfstate'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform destroy -state=some/state.tfstate some/configuration',
          any_args
        )
    )
  end

  it 'adds a backup option if a backup path is provided' do
    message = 'terraform destroy -backup=some/state.tfstate.backup ' \
              'some/configuration'
    command.execute(
      directory: config_dir,
      backup:    'some/state.tfstate.backup'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'disables backup if no_backup is true' do
    command.execute(
      directory: config_dir,
      backup:    'some/state.tfstate.backup',
      no_backup: true
    )

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform destroy -backup=- some/configuration', any_args)
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    command.execute(
      directory: 'some/path/to/terraform/configuration',
      no_color:  true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform destroy -no-color some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'forces the destroy when the force option is true' do
    command.execute(
      directory: 'some/path/to/terraform/configuration',
      force:     true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform destroy -force some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'adds a var-file option if a var file is provided' do
    command.execute(
      directory: config_dir,
      var_file:  'some/vars.tfvars'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform destroy -var-file=some/vars.tfvars some/configuration',
          any_args
        )
    )
  end

  it 'adds a var-file option for each element of var-files array' do
    message = 'terraform destroy -var-file=some/vars1.tfvars ' \
              '-var-file=some/vars2.tfvars some/configuration'
    command.execute(
      directory: config_dir,
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
    message = 'terraform destroy -var-file=some/vars.tfvars ' \
              '-var-file=some/vars1.tfvars ' \
              '-var-file=some/vars2.tfvars some/configuration'
    command.execute(
      directory: config_dir,
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

  it 'adds a target option if a target is provided' do
    command.execute(
      directory: config_dir,
      target:    'some_resource_name'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform destroy -target=some_resource_name some/configuration',
          any_args
        )
    )
  end

  it 'adds a target option for each element of target array' do
    message = 'terraform destroy -target=some_resource_1 ' \
              '-target=some_resource_2 some/configuration'
    command.execute(
      directory: config_dir,
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
    message = 'terraform destroy -target=some_resource_1 ' \
              '-target=some_resource_2 ' \
              '-target=some_resource_3 some/configuration'
    command.execute(
      directory: config_dir,
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

  it 'auto approves any query of the destroy ' \
     'when the auto-approve option is true' do
    command.execute(
      directory:    config_dir,
      auto_approve: true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform destroy -auto-approve=true some/configuration',
          any_args
        )
    )
  end
end
