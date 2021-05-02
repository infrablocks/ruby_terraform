# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::StateMove do
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
    described_class, 'state mv', :source
  )

  it_behaves_like(
    'a command with an argument',
    described_class, 'state mv', :destination
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'state mv'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'state mv', :dry_run
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'state mv', :backup
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'state mv', :backup_out
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'state mv', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'state mv', :lock_timeout
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'state mv', :state
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'state mv', :state_out
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'state mv', :ignore_remote_version
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'state mv'
  )
end
