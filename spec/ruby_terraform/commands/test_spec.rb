# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Test do
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
    described_class, 'test'
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'test', :json
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'test', :no_color
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'test', :verbose
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'test', :cloud_run
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'test', :test_directory
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'test', :filters
  )

  it_behaves_like(
    'a command that accepts vars',
    described_class, 'test'
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'test', :var_files
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'test'
  )
end
