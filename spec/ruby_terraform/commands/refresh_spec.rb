# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Refresh do
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
    described_class, 'refresh', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'refresh'
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'refresh', :backup
  )

  it_behaves_like(
    'a command that can disable backup',
    described_class, 'refresh'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'refresh', :compact_warnings
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'refresh', :input
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'refresh', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'refresh', :lock_timeout
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'refresh', :no_color
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'refresh', :parallelism
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'refresh', :state
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'refresh', :state_out
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'refresh', :targets
  )

  it_behaves_like(
    'a command that accepts vars',
    described_class, 'refresh'
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'refresh', :var_files
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'refresh'
  )
end
