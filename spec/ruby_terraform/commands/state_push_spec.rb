# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::StatePush do
  let(:command) { described_class.new(binary: 'terraform') }

  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  command = 'state push'

  it_behaves_like 'a command without a binary supplied',
                  [command, described_class]

  it_behaves_like 'a command with a flag', [command, :ignore_remote_version]

  it_behaves_like 'a command with common options', command
end
