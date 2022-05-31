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

  it_behaves_like(
    'a valid command line',
    described_class,
    reason: 'prefers the plan if both plan and directory provided',
    expected: 'terraform apply some/path/to/terraform/plan',
    binary: 'terraform',
    parameters: {
      directory: 'some/configuration/directory',
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
    described_class, 'apply'
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'apply', :auto_approve
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'apply', :backup
  )

  it_behaves_like(
    'a command that can disable backup',
    described_class, 'apply'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'apply', :compact_warnings
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'apply', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'apply', :lock_timeout
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'apply', :input
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'apply', :no_color
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'apply', :parallelism
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'apply', :refresh
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'apply', :state
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'apply', :state_out
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'apply', :targets
  )

  it_behaves_like(
    'a command that accepts vars',
    described_class, 'apply'
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'apply', :var_files
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'apply'
  )
  
  it_behaves_like(
    'a command with an array option',
    described_class, 'apply', :replaces
  )
end
