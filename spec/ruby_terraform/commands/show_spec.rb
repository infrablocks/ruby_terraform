# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Show do
  let(:command) { described_class.new(binary: 'terraform') }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  command = 'show'
  directory = Faker::File.dir

  it_behaves_like 'a valid command line', {
    reason: 'prefers the path if both path and directory provided',
    expected_command: 'terraform show some/path/to/terraform/plan',
    options: { directory: Faker::File.dir,
               path: 'some/path/to/terraform/plan' }
  }

  it_behaves_like(
    'a command with an argument', [command, :directory]
  )
  it_behaves_like(
    'a command with an argument', [command, :path]
  )
  it_behaves_like(
    'a command without a binary supplied',
    [command, described_class, directory]
  )
  it_behaves_like(
    'a command with a flag',
    [command, :no_color, directory]
  )
  it_behaves_like(
    'a command with a flag',
    [command, :json, directory]
  )
  it_behaves_like(
    'a command with common options',
    [command, directory]
  )
end
