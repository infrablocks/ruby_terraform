# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::ProvidersLock do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it_behaves_like(
    'a command with a variadic argument',
    described_class, 'providers lock', :providers
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'providers lock'
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'providers lock', :fs_mirror
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'providers lock', :net_mirror
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'providers lock', :platforms
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'providers lock'
  )
end
