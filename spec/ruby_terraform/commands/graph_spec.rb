# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Graph do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it_behaves_like(
    'a command with an argument',
    described_class, 'graph', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'graph'
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'graph', :plan
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'graph', :draw_cycles
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'graph', :type
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'graph', :module_depth
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'graph'
  )
end
