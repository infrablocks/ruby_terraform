# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Format do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'fmt'
  directory = Faker::File.dir

  it_behaves_like(
    'a command with an argument',
    [command, :directory]
  )

  it_behaves_like(
    'a command without a binary supplied',
    [command, described_class, directory]
  )

  it_behaves_like(
    'a command with a boolean option',
    [command, :list, directory]
  )

  it_behaves_like(
    'a command with a boolean option',
    [command, :write, directory]
  )

  it_behaves_like(
    'a command with a flag',
    [command, :diff, directory]
  )

  it_behaves_like(
    'a command with a flag',
    [command, :check, directory]
  )

  it_behaves_like(
    'a command with a flag',
    [command, :recursive, directory]
  )

  it_behaves_like(
    'a command with global options',
    [command, directory]
  )
end
