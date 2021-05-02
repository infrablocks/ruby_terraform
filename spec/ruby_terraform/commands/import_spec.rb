# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Import do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it_behaves_like(
    'a command with an option',
    described_class, 'import', :directory, name_override: '-config'
  )

  it_behaves_like(
    'a command with arguments',
    described_class, 'import', %i[address id]
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'import'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'import', :allow_missing_config
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'import', :backup
  )

  it_behaves_like(
    'a command that can disable backup',
    described_class, 'import'
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'import', :input
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'import', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'import', :lock_timeout
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'import', :no_color
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'import', :parallelism
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'import', :provider
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'import', :state
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'import', :state_out
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'import', :ignore_remote_version
  )

  it_behaves_like(
    'a command that accepts vars',
    described_class, 'import'
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'import', :var_files
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'import'
  )
end
