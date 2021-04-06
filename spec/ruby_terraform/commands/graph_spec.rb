# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Graph do
  let(:command) { described_class.new(binary: 'terraform') }

  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  command = 'graph'

  it_behaves_like 'a command without a binary supplied',
                  [command, described_class]

  it_behaves_like 'a command with an option', [command, :type]

  it_behaves_like 'a command with an option', [command, :module_depth]

  it_behaves_like 'a command with a flag', [command, :draw_cycles]

  it_behaves_like 'a command with common options', command
end
