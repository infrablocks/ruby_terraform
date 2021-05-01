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

  directory = Faker::File.dir

  it_behaves_like(
    'a valid command line',
    described_class,
    binary: 'terraform',
    options: { operation: 'new', workspace: 'staging' },
    reason: 'should create the specified workspace',
    expected: 'terraform workspace new staging'
  )

  it_behaves_like(
    'a command with an argument',
    described_class, 'workspace new', :workspace
  )

  it_behaves_like(
    'a command with an argument',
    described_class, 'workspace new', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'workspace new', directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'workspace new', :lock, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'workspace new', :lock_timeout, directory
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'workspace new', :state, directory
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'workspace new', directory
  )
end
