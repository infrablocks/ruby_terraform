# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::WorkspaceSelect do
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
    reason: 'should select the specified workspace',
    expected: 'terraform workspace select staging',
    binary: 'terraform',
    parameters: {
      name: 'staging'
    }
  )

  it_behaves_like(
    'a command with arguments',
    described_class, 'workspace select', %i[name directory]
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'workspace select'
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'workspace select'
  )
end
