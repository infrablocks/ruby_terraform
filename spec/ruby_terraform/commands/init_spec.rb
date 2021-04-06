# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Init do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'init'

  it_behaves_like('a command with an argument', [command, :path])

  it_behaves_like(
    'a command without a binary supplied',
    [command, described_class]
  )

  it_behaves_like(
    'a command with a boolean option',
    [command, :backend]
  )

  it_behaves_like(
    'a command with a map option',
    [command, :backend_config]
  )

  it_behaves_like('a command with a flag', [command, :force_copy])

  it_behaves_like(
    'a command with an option',
    [command, :from_module]
  )

  it_behaves_like(
    'a command with a boolean option',
    [command, :get]
  )

  it_behaves_like(
    'a command with a boolean option',
    [command, :get_plugins]
  )

  it_behaves_like(
    'a command with a boolean option',
    [command, :input]
  )

  it_behaves_like(
    'a command with a boolean option',
    [command, :lock]
  )

  it_behaves_like(
    'a command with an option',
    [command, :lock_timeout]
  )

  it_behaves_like('a command with a flag', [command, :no_color])

  it_behaves_like('a command with an option', [command, :plugin_dir])

  it_behaves_like('a command with a flag', [command, :reconfigure])

  it_behaves_like(
    'a command with a boolean option', [command, :upgrade]
  )

  it_behaves_like(
    'a command with a boolean option', [command, :verify_plugins]
  )

  it_behaves_like('a command with common options', command)
end
