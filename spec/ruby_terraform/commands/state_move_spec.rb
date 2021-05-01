# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::StateMove do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'state mv'

  it_behaves_like 'a command with an argument', [command, :source]

  it_behaves_like 'a command with an argument', [command, :destination]

  it_behaves_like 'a command without a binary supplied',
                  [command, described_class]

  it_behaves_like(
    'a command with an option', [command, :backup]
  )

  it_behaves_like(
    'a command that can disable backup', command
  )

  it_behaves_like(
    'a command with an option', [command, :backup_out]
  )

  it_behaves_like(
    'a command with an option', [command, :state]
  )

  it_behaves_like(
    'a command with an option', [command, :state_out]
  )

  it_behaves_like 'a command with a flag', [command, :ignore_remote_version]

  it_behaves_like 'a command with global options', command
end
