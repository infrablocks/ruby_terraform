require 'spec_helper'

describe RubyTerraform::Commands::Init do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform init command' do
    command = RubyTerraform::Commands::Init.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform init', any_args))

    command.execute
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Init.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary init', any_args))

    command.execute
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Init.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary init -no-color', any_args))

    command.execute(no_color: true)
  end

  it 'adds a backend-config option for each supplied backend config' do
    command = RubyTerraform::Commands::Init.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform init -backend-config 'thing=blah' " +
                      "-backend-config 'other=wah'", any_args))

    command.execute(
        backend_config: {
            thing: 'blah',
            other: 'wah'
        })
  end

  it 'uses the supplied module source when provided' do
    command = RubyTerraform::Commands::Init.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform init -from-module=some/module/source', any_args))

    command.execute(
        from_module: 'some/module/source')
  end

  it 'uses the supplied plugin directory when provided' do
    command = RubyTerraform::Commands::Init.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with('terraform init -plugin-dir=some/plugin/directory', any_args))

    command.execute(
      plugin_dir: 'some/plugin/directory')
  end

  it 'adds the supplied path when provided' do
    command = RubyTerraform::Commands::Init.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with(
                'terraform init -from-module=some/module/source some/output/path',
                any_args))

    command.execute(
        from_module: 'some/module/source',
        path: 'some/output/path')
  end

  it 'passes backend as false when specified' do
    command = RubyTerraform::Commands::Init.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with(
                'terraform init -backend=false',
                any_args))

    command.execute(
        backend: false)
  end

  it 'passes get as false when specified' do
    command = RubyTerraform::Commands::Init.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with(
                'terraform init -get=false',
                any_args))

    command.execute(
        get: false)
  end
end
