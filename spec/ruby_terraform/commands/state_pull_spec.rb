# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::StatePull do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'state pull'

  it_behaves_like 'a command without a binary supplied',
                  [command, described_class]

  it_behaves_like 'a command with common options', command
end
