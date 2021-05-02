# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Init do
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
    described_class, 'init', :path
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'init'
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'init', :backend
  )

  it_behaves_like(
    'a command with a map option',
    described_class, 'init', :backend_config
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'init', :force_copy
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'init', :from_module
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'init', :get
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'init', :get_plugins
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'init', :input
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'init', :lock
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'init', :lock_timeout
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'init', :no_color
  )

  it_behaves_like(
    'a command with an array option',
    described_class, 'init', :plugin_dirs
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'init', :reconfigure
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'init', :upgrade
  )

  it_behaves_like(
    'a command with a boolean option',
    described_class, 'init', :verify_plugins
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'init', :lockfile
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'init'
  )
end
