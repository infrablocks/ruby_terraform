# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Validate do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform validate command passing the supplied directory' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(directory: 'some/path/to/terraform/configuration')
    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform validate some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'defaults to the configured binary when none provided' do
    allow(Open4).to receive(:spawn)
    message = 'path/to/binary validate some/path/to/terraform/configuration'
    command = described_class.new

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'adds a var option for each supplied var' do
    allow(Open4).to receive(:spawn)
    message = "terraform validate -var 'first=1' -var 'second=two' " \
              'some/configuration'
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
        .with(message, any_args)
    )
  end

  it 'correctly serialises list/tuple vars' do
    allow(Open4).to receive(:spawn)
    message = "terraform validate -var 'list=[1,\"two\",3]' some/configuration"
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
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
    allow(Open4).to receive(:spawn)
    message = "terraform validate -var 'map={\"first\":1,\"second\":\"two\"}' "\
              'some/configuration'
    command = described_class.new(binary: 'terraform')

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
    message = "terraform validate -var 'list_of_maps=[{\"key\":\"value\"},"\
              "{\"key\":\"value\"}]' some/configuration"
    command = described_class.new(binary: 'terraform')

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
    message = 'terraform validate -state=some/state.tfstate some/configuration'
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      state:     'some/state.tfstate'
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    allow(Open4).to receive(:spawn)
    message = 'terraform validate -no-color ' \
              'some/path/to/terraform/configuration'
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/path/to/terraform/configuration',
      no_color:  true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'passes check-variables as false when specified' do
    allow(Open4).to receive(:spawn)

    message = 'terraform validate -check-variables=false ' \
              'some/path/to/terraform/configuration'
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory:       'some/path/to/terraform/configuration',
      check_variables: false
    )
    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'adds a var-file option for each element of var-files array' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    message = 'terraform validate -var-file=some/vars1.tfvars ' \
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
    message = 'terraform validate -var-file=some/vars.tfvars ' \
              '-var-file=some/vars1.tfvars -var-file=some/vars2.tfvars ' \
              'some/configuration'
    command = described_class.new(binary: 'terraform')

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

  it 'includes the json flag when the json option is true' do
    allow(Open4).to receive(:spawn)
    command = described_class.new(binary: 'terraform')

    command.execute(
      directory: 'some/configuration',
      json:      true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with('terraform validate -json some/configuration', any_args)
    )
  end
end
