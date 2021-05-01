# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::StateList do
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
    described_class, 'state list', :address
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'state list'
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'state list'
  )
end
