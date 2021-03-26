require 'spec_helper'

describe RubyTerraform::Commands::Workspace do
  let(:command) { described_class.new(binary: 'terraform') }

  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  terraform_command = 'workspace list'
  terraform_config_path = Faker::File.dir

  it_behaves_like 'a command with an argument', [terraform_command, :directory]

  it_behaves_like 'a command without a binary supplied', [terraform_command, described_class, terraform_config_path]

  it_behaves_like 'a valid command line', {
    options: nil,
    reason: 'should default to list operation when no operation provided',
    expected_command: 'terraform workspace list'
  }

  it_behaves_like 'a valid command line', {
    options: { operation: 'list', workspace: 'qa' },
    reason: 'should not use workspace option if operation list is provided',
    expected_command: 'terraform workspace list'
  }

  it_behaves_like 'a valid command line', {
    options: { operation: 'select', workspace: 'staging' },
    reason: 'should select the specified workspace',
    expected_command: 'terraform workspace select staging'
  }

  it_behaves_like 'a valid command line', {
    options: { operation: 'new', workspace: 'staging' },
    reason: 'should create the specified workspace',
    expected_command: 'terraform workspace new staging'
  }

  it_behaves_like 'a valid command line', {
    options: { operation: 'delete', workspace: 'staging' },
    reason: 'should delete the specified workspace',
    expected_command: 'terraform workspace delete staging'
  }
end
