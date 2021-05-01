# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::ProvidersLock do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'providers lock'

  it_behaves_like(
    'a command without a binary supplied',
    [command, described_class]
  )

  it_behaves_like(
    'a command with an argument', [command, :providers]
  )

  it_behaves_like(
    'a command without a binary supplied',
    [command, described_class]
  )

  it_behaves_like(
    'a command with an option', [command, :fs_mirror]
  )

  it_behaves_like(
    'a command with an option', [command, :net_mirror]
  )

  it_behaves_like(
    'a command with an array option',
    [command, :platforms]
  )

  it_behaves_like(
    'a command with global options', command
  )
end
