require 'spec_helper'

describe RubyTerraform::Commands::Destroy do
  let(:command) { described_class.new(binary: 'terraform') }

  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
      config.logger = Logger.new(StringIO.new)
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  terraform_command = 'destroy'
  terraform_config_path = Faker::File.dir

  it_behaves_like 'a command that accepts global options', [terraform_command, terraform_config_path]

  it_behaves_like 'a command with an argument', [terraform_command, :directory]

  it_behaves_like 'a command without a binary supplied', [terraform_command, described_class, terraform_config_path]

  it_behaves_like 'a command that accepts vars', [terraform_command, terraform_config_path]

  it_behaves_like 'a command that can disable backup', [terraform_command, terraform_config_path]

  it_behaves_like 'a command with a boolean option', [terraform_command, :auto_approve, terraform_config_path]

  it_behaves_like 'a command with an array option', [terraform_command, :targets, terraform_config_path]

  it_behaves_like 'a command with an array option', [terraform_command, :var_files, terraform_config_path]

  it_behaves_like 'a command with an option', [terraform_command, :backup, terraform_config_path]

  it_behaves_like 'a command with an option', [terraform_command, :state, terraform_config_path]

  it_behaves_like 'a command with a flag', [terraform_command, :force, terraform_config_path]

  it_behaves_like 'a command with a flag', [terraform_command, :no_color, terraform_config_path]
end
