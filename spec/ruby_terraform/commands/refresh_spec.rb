# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Refresh do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform refresh command passing the supplied directory' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform refresh some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'defaults to the configured binary when none provided' do
    allow(Open4).to receive(:spawn)
    command = described_class.new

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'path/to/binary refresh some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'adds a var option for each supplied var' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = "terraform refresh -var 'first=1' -var 'second=two' " \
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
          "terraform refresh -var 'list=[1,\"two\",3]' some/configuration",
          any_args
        )
    )
  end

  it 'correctly serialises map/object vars' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = "terraform refresh -var 'map={\"first\":1,\"second\":\"two\"}' " \
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
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = "terraform refresh -var 'list_of_maps=[{\"key\":\"value\"}," \
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
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      state:     'some/state.tfstate'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform refresh -state=some/state.tfstate some/configuration',
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
          'terraform refresh -no-color some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'adds a var-file option for each element of var-files array' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = 'terraform refresh -var-file=some/vars1.tfvars ' \
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
    message = 'terraform refresh -var-file=some/vars.tfvars -var-file=some/' \
              'vars1.tfvars -var-file=some/vars2.tfvars some/configuration'
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
          'terraform refresh -target=some_resource_name some/configuration',
          any_args
        )
    )
  end

  it 'adds a target option for each element of target array' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = 'terraform refresh -target=some_resource_1 ' \
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
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')
    message = 'terraform refresh -target=some_resource_1 ' \
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
