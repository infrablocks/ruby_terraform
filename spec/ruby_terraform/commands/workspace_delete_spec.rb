# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::WorkspaceDelete do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'workspace delete'
  directory = Faker::File.dir

  it_behaves_like 'a valid command line', {
    options: { operation: 'delete', workspace: 'staging' },
    reason: 'should delete the specified workspace',
    expected_command: 'terraform workspace delete staging'
  }

  it_behaves_like(
    'a command with an argument', [command, :workspace]
  )

  it_behaves_like(
    'a command with an argument', [command, :directory]
  )

  it_behaves_like(
    'a command without a binary supplied',
    [command, described_class, directory]
  )

  it_behaves_like(
    'a command with a flag', [command, :force, directory]
  )

  it_behaves_like(
    'a command with a boolean option', [command, :lock, directory]
  )

  it_behaves_like(
    'a command with an option', [command, :lock_timeout, directory]
  )

  it_behaves_like(
    'a command with common options', [command, directory]
  )
end
