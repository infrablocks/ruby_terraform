# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Validate do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  directory = Faker::File.dir

  it_behaves_like(
    'a command with an argument',
    described_class, 'validate', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'validate', directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'validate', :json, directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'validate', :no_color, directory
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'validate', directory
  )
end
