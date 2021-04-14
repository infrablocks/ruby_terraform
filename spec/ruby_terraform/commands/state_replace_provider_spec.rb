# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::StateReplaceProvider do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'state replace-provider'

  it_behaves_like 'a command with an argument', [command, :from]

  it_behaves_like 'a command with an argument', [command, :to]

  it_behaves_like 'a command without a binary supplied',
                  [command, described_class]

  it_behaves_like(
    'a command with a boolean option', [command, :auto_approve]
  )

  it_behaves_like(
    'a command with an option', [command, :backup]
  )

  it_behaves_like(
    'a command that can disable backup', command
  )

  it_behaves_like(
    'a command with a boolean option', [command, :lock]
  )

  it_behaves_like(
    'a command with an option', [command, :lock_timeout]
  )

  it_behaves_like(
    'a command with an option', [command, :state]
  )

  it_behaves_like 'a command with a flag', [command, :ignore_remote_version]

  it_behaves_like 'a command with common options', command
end
