require 'spec_helper'

describe RubyTerraform::Commands::Get do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform get command passing the supplied directory' do
    command = RubyTerraform::Commands::Get.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform get some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Get.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary get some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'passes the update option as true when the update option is true' do
    command = RubyTerraform::Commands::Get.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary get -update=true some/path/to/terraform/configuration', any_args))

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        update: true)
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Get.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary get -no-color some/path/to/terraform/configuration', any_args))

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        no_color: true)
  end
end
