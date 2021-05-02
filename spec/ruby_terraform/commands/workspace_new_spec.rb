# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::WorkspaceNew do
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
    reason: 'should create the specified workspace',
    expected: 'terraform workspace new staging',
    binary: 'terraform',
    parameters: {
      name: 'staging'
    }
  )

  it_behaves_like(
    'a command with arguments',
    described_class, 'workspace new', %i[name directory]
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'workspace new'
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'workspace new', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'workspace new', :lock_timeout
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'workspace new', :state
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'workspace new'
  )
end
