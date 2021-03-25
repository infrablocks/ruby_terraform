require 'spec_helper'

describe RubyTerraform::Commands::RemoteConfig do
  let(:command) { described_class.new(binary: 'terraform') }

  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  terraform_command = 'remote config'

  it_behaves_like 'a command without a binary supplied', [terraform_command, described_class]

  it_behaves_like 'a command with a map option', [terraform_command, :backend_config]

  it_behaves_like 'a command with an option', [terraform_command, :backend]

  it_behaves_like 'a command with a flag', [terraform_command, :no_color]
end

