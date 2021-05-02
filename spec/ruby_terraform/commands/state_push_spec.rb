# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::StatePush do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'state push'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'state push', :force
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'state push', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'state push', :lock_timeout
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'state push', :ignore_remote_version
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'state push'
  )
end
