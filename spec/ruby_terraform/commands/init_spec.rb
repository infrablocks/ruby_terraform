require 'spec_helper'

describe RubyTerraform::Commands::Init do
  let(:command) { described_class.new(binary: 'terraform') }

  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  terraform_command = 'init'

  it_behaves_like 'a command that accepts global options', terraform_command

  it_behaves_like 'a command with an argument', [terraform_command, :path]

  it_behaves_like 'a command without a binary supplied', [terraform_command, described_class]

  it_behaves_like 'a command with a boolean option', [terraform_command, :backend]

  it_behaves_like 'a command with a boolean option', [terraform_command, :force_copy]

  it_behaves_like 'a command with a boolean option', [terraform_command, :get]

  it_behaves_like 'a command with a boolean option', [terraform_command, :get_plugins]

  it_behaves_like 'a command with a boolean option', [terraform_command, :input]

  it_behaves_like 'a command with a boolean option', [terraform_command, :lock]

  it_behaves_like 'a command with a boolean option', [terraform_command, :upgrade]

  it_behaves_like 'a command with a boolean option', [terraform_command, :verify_plugins]

  it_behaves_like 'a command with a map option', [terraform_command, :backend_config]

  it_behaves_like 'a command with an option', [terraform_command, :from_module]

  it_behaves_like 'a command with an option', [terraform_command, :lock_timeout]

  it_behaves_like 'a command with an option', [terraform_command, :plugin_dir]

  it_behaves_like 'a command with a flag', [terraform_command, :no_color]

  it_behaves_like 'a command with a flag', [terraform_command, :reconfigure]

end
