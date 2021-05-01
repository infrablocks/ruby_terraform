# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Apply do
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
    'a valid command line',
    described_class,
    binary: 'terraform',
    reason: 'prefers the plan if both plan and directory provided',
    expected: 'terraform apply some/path/to/terraform/plan',
    options: {
      directory: directory,
      plan: 'some/path/to/terraform/plan'
    }
  )

  it_behaves_like(
    'a command with an argument',
    described_class, 'apply', :directory
  )

  it_behaves_like(
    'a command with an argument',
    described_class, 'apply', :plan
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'apply', directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'apply', :backup, directory
  )

  it_behaves_like(
    'a command that can disable backup',
    described_class, 'apply', directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'apply', :compact_warnings, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'apply', :lock, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'apply', :lock_timeout, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'apply', :input, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'apply', :auto_approve, directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'apply', :no_color, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'apply', :parallelism, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'apply', :refresh, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'apply', :state, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'apply', :state_out, directory
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'apply', :targets, directory
  )

  it_behaves_like(
    'a command that accepts vars',
    described_class, 'apply', directory
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'apply', :var_files, directory
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'apply', directory
  )
end
