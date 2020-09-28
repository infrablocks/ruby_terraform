# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Show do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform show command passing the supplied directory' do
    allow(Open4).to receive(:spawn)

    command = described_class.new(binary: 'terraform')

    command.execute(path: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'terraform show some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'defaults to the configured binary when none provided' do
    allow(Open4).to receive(:spawn)
    command = described_class.new

    command.execute(path: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'path/to/binary show some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'passes the update option as true when the update option is true' do
    allow(Open4).to receive(:spawn)
    message = 'path/to/binary show -module-depth=0 ' \
              'some/path/to/terraform/configuration'
    command = described_class.new

    command.execute(
      path:         'some/path/to/terraform/configuration',
      module_depth: 0
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    allow(Open4).to receive(:spawn)

    command = described_class.new

    command.execute(
      path:     'some/path/to/terraform/configuration',
      no_color: true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'path/to/binary show -no-color some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'includes the json flag when the json option is true' do
    allow(Open4).to receive(:spawn)

    command = described_class.new

    command.execute(
      path: 'some/path/to/terraform/configuration',
      json: true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'path/to/binary show -json some/path/to/terraform/configuration',
          any_args
        )
    )
  end
end
