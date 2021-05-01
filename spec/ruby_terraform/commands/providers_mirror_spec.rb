# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::ProvidersMirror do
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
    described_class, 'providers mirror'
  )

  it_behaves_like(
    'a command with an argument',
    described_class, 'providers mirror', :directory
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'providers mirror', :platforms
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'providers mirror'
  )
end
