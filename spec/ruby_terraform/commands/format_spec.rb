# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Format do
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
    described_class, 'fmt', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'fmt'
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'fmt', :list
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'fmt', :write
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'fmt', :diff
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'fmt', :check
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'fmt', :no_color
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'fmt', :recursive
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'fmt'
  )
end
