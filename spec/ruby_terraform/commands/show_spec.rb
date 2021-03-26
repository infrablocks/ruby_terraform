require 'spec_helper'

describe RubyTerraform::Commands::Show do
  let(:command) { described_class.new(binary: 'terraform') }

  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  terraform_command = 'show'
  terraform_config_path = Faker::File.dir

  it_behaves_like 'a command with an argument', [terraform_command, :directory]

  it_behaves_like 'a command without a binary supplied', [terraform_command, described_class, terraform_config_path]

  it_behaves_like 'a command with an option', [terraform_command, :module_depth, terraform_config_path]

  it_behaves_like 'a command with a flag', [terraform_command, :no_color, terraform_config_path]

  it_behaves_like 'a command with a flag', [terraform_command, :json, terraform_config_path]
end
