# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::RemoteConfig do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform remote config command' do
    allow(Open4).to receive(:spawn)

    command = described_class.new(binary: 'terraform')

    command.execute

    expect(Open4).to(
      have_received(:spawn)
        .with('terraform remote config', any_args)
    )
  end

  it 'defaults to the configured binary when none provided' do
    allow(Open4).to receive(:spawn)

    command = described_class.new

    command.execute

    expect(Open4).to(
      have_received(:spawn)
        .with('path/to/binary remote config', any_args)
    )
  end

  it 'uses the provided backend when supplied' do
    allow(Open4).to receive(:spawn)

    command = described_class.new

    command.execute(backend: 's3')

    expect(Open4).to(
      have_received(:spawn)
          .with('path/to/binary remote config -backend=s3', any_args)
    )
  end

  it 'adds a backend-config option for each supplied backend config' do
    allow(Open4).to receive(:spawn)
    message = "terraform remote config -backend-config 'thing=blah' " \
              "-backend-config 'other=wah'"
    command = described_class.new(binary: 'terraform')

    command.execute(
      backend_config: {
        thing: 'blah',
        other: 'wah'
      }
    )

    expect(Open4).to(
      have_received(:spawn)
        .with(message, any_args)
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    allow(Open4).to receive(:spawn)

    command = described_class.new

    command.execute(no_color: true)

    expect(Open4).to(
      have_received(:spawn)
          .with('path/to/binary remote config -no-color', any_args)
    )
  end
end
