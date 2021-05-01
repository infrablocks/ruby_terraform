# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Untaint do
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
    described_class, 'untaint', :name
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'untaint'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'untaint', :allow_missing
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'untaint', :backup
  )

  it_behaves_like(
    'a command that can disable backup',
    described_class, 'untaint'
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'untaint', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'untaint', :lock_timeout
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'untaint', :no_color
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'untaint', :state
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'untaint', :state_out
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'untaint', :ignore_remote_version
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'untaint'
  )
end
