# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::ForceUnlock do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  it_behaves_like(
    'a command with arguments',
    described_class, 'force-unlock', %i[lock_id directory]
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'force-unlock'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'force-unlock', :force
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'force-unlock'
  )
end
