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

  directory = Faker::File.dir

  it_behaves_like(
    'a command with an argument',
    described_class, 'destroy', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'destroy', directory
  )

  it_behaves_like(
    'a command with an argument',
    described_class, 'destroy', :directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'destroy', :backup, directory
  )

  it_behaves_like(
    'a command that can disable backup',
    described_class, 'destroy', directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'destroy', :compact_warnings, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'destroy', :lock, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'destroy', :lock_timeout, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'destroy', :input, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'destroy', :auto_approve, directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'destroy', :no_color, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'destroy', :parallelism, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'destroy', :refresh, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'destroy', :state, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'destroy', :state_out, directory
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'destroy', :targets, directory
  )

  it_behaves_like(
    'a command that accepts vars',
    described_class, 'destroy', directory
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'destroy', :var_files, directory
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'destroy', directory
  )
end
