# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Workspace do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform workspace command passing the supplied directory' do
    command = described_class.new(binary: 'terraform')

    allow(Open4).to receive(:spawn)

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform workspace list some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    allow(Open4).to receive(:spawn)

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'path/to/binary workspace list some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'defaults to list operation when no operation provided' do
    command = described_class.new

    allow(Open4).to receive(:spawn)

    command.execute

    expect(Open4).to(
      have_received(:spawn)
        .with('path/to/binary workspace list', any_args)
    )
  end

  it 'does not use workspace option if operation list is provided' do
    command = described_class.new

    allow(Open4).to receive(:spawn)

    command.execute(operation: 'list', workspace: 'qa')

    expect(Open4).to(
      have_received(:spawn)
        .with('path/to/binary workspace list', any_args)
    )
  end

  it 'selects the specified workspace' do
    command = described_class.new

    allow(Open4).to receive(:spawn)

    command.execute(operation: 'select', workspace: 'staging')

    expect(Open4).to(
      have_received(:spawn)
        .with('path/to/binary workspace select staging', any_args)
    )
  end

  it 'creates the specified workspace' do
    command = described_class.new

    allow(Open4).to receive(:spawn)

    command.execute(operation: 'new', workspace: 'staging')

    expect(Open4).to(
      have_received(:spawn)
        .with('path/to/binary workspace new staging', any_args)
    )
  end

  it 'deletes the specified workspace' do
    command = described_class.new
    allow(Open4).to receive(:spawn)

    command.execute(operation: 'delete', workspace: 'staging')

    expect(Open4).to(
      have_received(:spawn)
        .with('path/to/binary workspace delete staging', any_args)
    )
  end
end
