# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::WorkspaceSelect do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'workspace select'
  directory = Faker::File.dir

  it_behaves_like(
    'a valid command line', {
      options: { operation: 'select', workspace: 'staging' },
      reason: 'should select the specified workspace',
      expected_command: 'terraform workspace select staging'
    }
  )

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
    'a command with common options', [command, directory]
  )
end
