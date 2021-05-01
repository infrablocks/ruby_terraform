# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::WorkspaceList do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'workspace list'
  directory = Faker::File.dir

  it_behaves_like(
    'a valid command line', {
      options: { operation: 'list', workspace: 'qa' },
      reason: 'should not use workspace option if operation list is provided',
      expected_command: 'terraform workspace list'
    }
  )

  it_behaves_like(
    'a command with an argument', [command, :directory]
  )

  it_behaves_like(
    'a command without a binary supplied',
    [command, described_class, directory]
  )

  it_behaves_like(
    'a command with global options', [command, directory]
  )
end
