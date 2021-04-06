# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::RemoteConfig do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'remote config'

  it_behaves_like(
    'a command without a binary supplied', [command, described_class]
  )

  it_behaves_like(
    'a command with a map option', [command, :backend_config]
  )

  it_behaves_like(
    'a command with a boolean option', [command, :backend]
  )

  it_behaves_like(
    'a command with a flag', [command, :no_color]
  )
end
