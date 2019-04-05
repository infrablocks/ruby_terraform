require 'spec_helper'

describe RubyTerraform::Commands::Workspace do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform workspace command passing the supplied directory' do
    command = RubyTerraform::Commands::Workspace.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform workspace list some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Workspace.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary workspace list some/path/to/terraform/configuration', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'should defaults to list operation when no operation provided' do
    command = RubyTerraform::Commands::Workspace.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary workspace list', any_args))

    command.execute
  end

  it 'should not use workspace option if operation list is provided' do
    command = RubyTerraform::Commands::Workspace.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary workspace list', any_args))

    command.execute(operation: 'list', workspace: 'qa')
  end

  it 'should select the specified workspace' do
    command = RubyTerraform::Commands::Workspace.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary workspace select staging', any_args))

    command.execute(operation: 'select', workspace: 'staging')
  end

  it 'should create the specified workspace' do
    command = RubyTerraform::Commands::Workspace.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary workspace new staging', any_args))

    command.execute(operation: 'new', workspace: 'staging')
  end

  it 'should delete the specified workspace' do
    command = RubyTerraform::Commands::Workspace.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary workspace delete staging', any_args))

    command.execute(operation: 'delete', workspace: 'staging')
  end
end
