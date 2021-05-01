# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Providers do
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
    described_class, 'providers'
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'providers'
  )
end
