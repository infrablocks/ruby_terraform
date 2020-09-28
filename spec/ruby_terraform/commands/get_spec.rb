# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Get do
  let(:command) { described_class.new }
  let(:terra_dir) { 'some/path/to/terraform/configuration' }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
    allow(Open4).to receive(:spawn)
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform get command passing the supplied directory' do
    command = described_class.new(binary: 'terraform')

    command.execute(directory: terra_dir)

    expect(Open4).to(
      have_received(:spawn)
        .with('terraform get some/path/to/terraform/configuration', any_args)
    )
  end

  it 'defaults to the configured binary when none provided' do
    command.execute(directory: terra_dir)

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'path/to/binary get some/path/to/terraform/configuration',
          any_args
        )
    )
  end

  it 'passes the update option as true when the update option is true' do
    message = 'path/to/binary get -update=true ' \
              'some/path/to/terraform/configuration'
    command.execute(
      directory: terra_dir,
      update:    true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    command.execute(
      directory: terra_dir,
      no_color:  true
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(
          'path/to/binary get -no-color some/path/to/terraform/configuration',
          any_args
        )
    )
  end
end
