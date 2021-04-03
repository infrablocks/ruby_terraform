require 'spec_helper'

describe RubyTerraform::Commands::Apply do
  let(:command) { described_class.new(binary: 'terraform') }

  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  terraform_command = 'apply'
  terraform_config_path = Faker::File.dir

  it_behaves_like 'a command with an argument', [terraform_command, :directory]

  it_behaves_like 'a command with an argument', [terraform_command, :plan]

  it_behaves_like 'a valid command line', {
    reason: 'prefers the plan if both plan and directory provided',
    expected_command: 'terraform apply some/path/to/terraform/plan',
    options: { directory: Faker::File.dir,
               plan: 'some/path/to/terraform/plan' }
  }

  it_behaves_like 'a command without a binary supplied', [terraform_command, described_class, terraform_config_path]

  it_behaves_like 'a command that accepts vars', [terraform_command, terraform_config_path]

  it_behaves_like 'a command with an option', [terraform_command, :state, terraform_config_path]

  it_behaves_like 'a command with an option', [terraform_command, :backup, terraform_config_path]

  it_behaves_like 'a command that can disable backup', [terraform_command, terraform_config_path]

  it_behaves_like 'a command with a flag', [terraform_command, :no_color, terraform_config_path]

  it_behaves_like 'a command with an array option', [terraform_command, :var_files, terraform_config_path]

  it_behaves_like 'a command with a boolean option', [terraform_command, :auto_approve, terraform_config_path]

  it_behaves_like 'a command with a boolean option', [terraform_command, :input, terraform_config_path]

  it_behaves_like 'a command with an array option', [terraform_command, :targets, terraform_config_path]
end
