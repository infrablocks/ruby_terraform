# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::WorkspaceList do
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
    reason: 'should not use workspace option if operation list is provided',
    expected: 'terraform workspace list',
    binary: 'terraform',
    parameters: {
      workspace: 'qa'
    }
  )

  it_behaves_like(
    'a command with an argument',
    described_class, 'workspace list', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'workspace list'
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'workspace list'
  )
end
