require 'spec_helper'

describe RubyTerraform::Commands::Show do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform show command passing the supplied directory' do
    command = RubyTerraform::Commands::Show.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform show some/path/to/terraform/configuration', any_args))

    command.execute(path: 'some/path/to/terraform/configuration')
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Show.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary show some/path/to/terraform/configuration', any_args))

    command.execute(path: 'some/path/to/terraform/configuration')
  end

  it 'passes the update option as true when the update option is true' do
    command = RubyTerraform::Commands::Show.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary show -module-depth=0 some/path/to/terraform/configuration', any_args))

    command.execute(
        path: 'some/path/to/terraform/configuration',
        module_depth: 0)
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Show.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary show -no-color some/path/to/terraform/configuration', any_args))

    command.execute(
        path: 'some/path/to/terraform/configuration',
        no_color: true)
  end
end
