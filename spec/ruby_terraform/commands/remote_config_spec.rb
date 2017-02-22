require 'spec_helper'

describe RubyTerraform::Commands::RemoteConfig do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform remote config command' do
    command = RubyTerraform::Commands::RemoteConfig.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform remote config', any_args))

    command.execute
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::RemoteConfig.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary remote config', any_args))

    command.execute
  end

  it 'uses the provided backend when supplied' do
    command = RubyTerraform::Commands::RemoteConfig.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary remote config -backend=s3', any_args))

    command.execute(backend: 's3')
  end

  it 'adds a backend-config option for each supplied backend config' do
    command = RubyTerraform::Commands::RemoteConfig.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform remote config -backend-config 'thing=blah' -backend-config 'other=wah'", any_args))

    command.execute(
        backend_config: {
            thing: 'blah',
            other: 'wah'
        })
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::RemoteConfig.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary remote config -no-color', any_args))

    command.execute(no_color: true)
  end
end
