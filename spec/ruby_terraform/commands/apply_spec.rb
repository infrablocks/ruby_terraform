# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Apply do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
    allow(Open4).to receive(:spawn)
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform apply command passing the supplied directory' do
    command = described_class.new(binary: 'terraform')

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with('terraform apply some/path/to/terraform/configuration', any_args)
    )
  end

  it 'calls the terraform apply command passing the supplied plan' do
    command = described_class.new(binary: 'terraform')

    command.execute(plan: 'some/path/to/terraform/plan')

    expect(Open4).to(
      have_received(:spawn)
        .with('terraform apply some/path/to/terraform/plan', any_args)
    )
  end

  it 'prefers the plan if both plan and directory provided' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      plan:      'some/path/to/terraform/plan'
    )

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform apply some/path/to/terraform/plan', any_args)
    )
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'path/to/binary apply some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'adds a var option for each supplied var' do
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
          "terraform apply -var 'first=1' -var 'second=two' some/configuration",
          any_args
        )
    )
  end

  it 'correctly serialises list/tuple vars' do
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
          "terraform apply -var 'list=[1,\"two\",3]' some/configuration",
          any_args
        )
    )
  end

  it 'correctly serialises map/object vars' do
    command = described_class.new(binary: 'terraform')
    message = "terraform apply -var 'map={\"first\":1,\"second\":\"two\"}' " \
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
    message = "terraform apply -var 'list_of_maps=[{\"key\":\"value\"}," \
              "{\"key\":\"value\"}]' some/configuration"

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
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      state:     'some/state.tfstate'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform apply -state=some/state.tfstate some/configuration',
          any_args
        )
    )
  end

  it 'adds a backup option if a backup path is provided' do
    command = described_class.new(binary: 'terraform')
    message = 'terraform apply -backup=some/state.tfstate.backup ' \
              'some/configuration'
    command.execute(
      directory: 'some/configuration',
      backup:    'some/state.tfstate.backup'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'disables backup if no_backup is true' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      backup:    'some/state.tfstate.backup',
      no_backup: true
    )

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform apply -backup=- some/configuration', any_args)
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      no_color:  true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform apply -no-color some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'adds a var-file option if a var file is provided' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      var_file:  'some/vars.tfvars'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform apply -var-file=some/vars.tfvars some/configuration',
          any_args
        )
    )
  end

  it 'adds a var-file option for each element of var-files array' do
    command = described_class.new(binary: 'terraform')
    message = 'terraform apply -var-file=some/vars1.tfvars ' \
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
    command = described_class.new(binary: 'terraform')
    message = 'terraform apply -var-file=some/vars.tfvars ' \
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

  it 'passes auto-approve of true when the auto_approve option is true' do
    command = described_class.new(binary: 'terraform')
    message = 'terraform apply -auto-approve=true ' \
              'some/path/to/terraform/configuration'

    command.execute(
      directory:    'some/path/to/terraform/configuration',
      auto_approve: true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'passes auto-approve of false when the auto_approve option is false' do
    command = described_class.new(binary: 'terraform')
    message = 'terraform apply -auto-approve=false ' \
              'some/path/to/terraform/configuration'
    command.execute(
      directory:    'some/path/to/terraform/configuration',
      auto_approve: false
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'adds a input option if a input value is provided' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      input:     'false'
    )

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform apply -input=false some/configuration', any_args)
    )
  end

  it 'adds a target option if a target is provided' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      target:    'some_resource_name'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform apply -target=some_resource_name some/configuration',
          any_args
        )
    )
  end

  it 'adds a target option for each element of target array' do
    command = described_class.new(binary: 'terraform')
    message = 'terraform apply -target=some_resource_1 ' \
              '-target=some_resource_2 some/configuration'

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
    command = described_class.new(binary: 'terraform')
    message = 'terraform apply -target=some_resource_1 ' \
              '-target=some_resource_2 -target=some_resource_3 ' \
              'some/configuration'
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
end
