# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Init do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
    allow(Open4).to receive(:spawn)
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform init command' do
    command = described_class.new(binary: 'terraform')

    command.execute

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform init', any_args)
    )
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute

    expect(Open4).to(
      have_received(:spawn)
          .with('path/to/binary init', any_args)
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = described_class.new

    command.execute(no_color: true)

    expect(Open4).to(
      have_received(:spawn)
          .with('path/to/binary init -no-color', any_args)
    )
  end

  it 'includes the force-copy flag when the force_copy option is true' do
    command = described_class.new

    command.execute(force_copy: true)

    expect(Open4).to(
      have_received(:spawn)
          .with('path/to/binary init -force-copy=true', any_args)
    )
  end

  it 'adds a backend-config option for each supplied backend config' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      backend_config: {
        thing: 'blah',
        other: 'wah'
      }
    )

    expect(Open4).to(
      have_received(:spawn)
          .with("terraform init -backend-config 'thing=blah' " \
                    "-backend-config 'other=wah'", any_args
          )
    )
  end

  it 'uses the supplied module source when provided' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      from_module: 'some/module/source'
    )

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform init -from-module=some/module/source', any_args)
    )
  end

  it 'uses the supplied plugin directory when provided' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      plugin_dir: 'some/plugin/directory'
    )

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform init -plugin-dir=some/plugin/directory', any_args)
    )
  end

  it 'adds the supplied path when provided' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      from_module: 'some/module/source',
      path:        'some/output/path'
    )

    expect(Open4).to(
      have_received(:spawn)
          .with(
            'terraform init -from-module=some/module/source some/output/path',
            any_args
          )
    )
  end

  it 'passes backend as false when specified' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      backend: false
    )

    expect(Open4).to(
      have_received(:spawn)
          .with(
            'terraform init -backend=false',
            any_args
          )
    )
  end

  it 'passes get as false when specified' do
    command = described_class.new(binary: 'terraform')

    command.execute(
      get: false
    )

    expect(Open4).to(
      have_received(:spawn)
          .with(
            'terraform init -get=false',
            any_args
          )
    )
  end
end
