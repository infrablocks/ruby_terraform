# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Taint do
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
    described_class, 'taint', :address
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'taint'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'taint', :allow_missing
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'taint', :backup
  )

  it_behaves_like(
    'a command that can disable backup',
    described_class, 'taint'
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'taint', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'taint', :lock_timeout
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'taint', :state
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'taint', :state_out
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'taint', :ignore_remote_version
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'taint'
  )
end
