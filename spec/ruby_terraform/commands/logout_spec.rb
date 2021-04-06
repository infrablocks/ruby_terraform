# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Logout do
  let(:command) { described_class.new(binary: 'terraform') }

  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  command = 'logout'

  it_behaves_like 'a command with an argument', [command, :hostname]

  it_behaves_like 'a command without a binary supplied',
                  [command, described_class]
end
