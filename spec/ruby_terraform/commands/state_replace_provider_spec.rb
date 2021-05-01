# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::StateReplaceProvider do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it_behaves_like(
    'a command with an argument',
    described_class, 'state replace-provider', :from
  )

  it_behaves_like(
    'a command with an argument',
    described_class, 'state replace-provider', :to
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'state replace-provider'
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'state replace-provider', :auto_approve
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'state replace-provider', :backup
  )

  it_behaves_like(
    'a command that can disable backup',
    described_class, 'state replace-provider'
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'state replace-provider', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'state replace-provider', :lock_timeout
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'state replace-provider', :state
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'state replace-provider', :ignore_remote_version
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'state replace-provider'
  )
end
