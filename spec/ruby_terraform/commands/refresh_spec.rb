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

  directory = Faker::File.dir

  it_behaves_like(
    'a command with an argument',
    described_class, 'refresh', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'refresh', directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'refresh', :backup, directory
  )

  it_behaves_like(
    'a command that can disable backup',
    described_class, 'refresh', directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'refresh', :compact_warnings, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'refresh', :input, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'refresh', :lock, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'refresh', :lock_timeout, directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'refresh', :no_color, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'refresh', :parallelism, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'refresh', :state, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'refresh', :state_out, directory
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'refresh', :targets, directory
  )

  it_behaves_like(
    'a command that accepts vars',
    described_class, 'refresh', directory
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'refresh', :var_files, directory
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'refresh', directory
  )
end
