# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Format do
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
    described_class, 'fmt', :directory
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'fmt', directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'fmt', :list, directory
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'fmt', :write, directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'fmt', :diff, directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'fmt', :check, directory
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'fmt', :recursive, directory
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'fmt', directory
  )
end
