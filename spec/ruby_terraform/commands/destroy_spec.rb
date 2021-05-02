# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Destroy do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
      config.logger = Logger.new(StringIO.new)
    end
  end

  after do
    RubyTerraform.reset!
  end

  it_behaves_like(
    'a command with an argument',
    described_class, 'destroy', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'destroy'
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'destroy', :auto_approve
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'destroy', :backup
  )

  it_behaves_like(
    'a command that can disable backup',
    described_class, 'destroy'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'destroy', :compact_warnings
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'destroy', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'destroy', :lock_timeout
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'destroy', :input
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'destroy', :no_color
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'destroy', :parallelism
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'destroy', :refresh
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'destroy', :state
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'destroy', :state_out
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'destroy', :targets
  )

  it_behaves_like(
    'a command that accepts vars',
    described_class, 'destroy'
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'destroy', :var_files
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'destroy'
  )
end
