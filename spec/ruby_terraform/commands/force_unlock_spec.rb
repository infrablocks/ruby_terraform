# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::ForceUnlock do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'force-unlock'

  it_behaves_like 'a command with an argument', [command, :lock_id]

  it_behaves_like 'a command without a binary supplied',
                  [command, described_class]

  it_behaves_like 'a command with a flag', [command, :force]

  it_behaves_like 'a command with common options', command
end
