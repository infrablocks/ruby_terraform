require 'spec_helper'

describe RubyTerraform::Commands::Clean do
  it 'deletes the .terraform directory in the current directory by default' do
    command = RubyTerraform::Commands::Clean.new

    expect(FileUtils).to(
        receive(:rm_rf).with('.terraform'))

    command.execute
  end

  it 'deletes the provided directory when specified' do
    command = RubyTerraform::Commands::Clean.new(directory: 'some/path')

    expect(FileUtils).to(
        receive(:rm_rf).with('some/path'))

    command.execute
  end

  it 'allows the directory to be overridden on execution' do
    command = RubyTerraform::Commands::Clean.new

    expect(FileUtils).to(
        receive(:rm_rf).with('some/.terraform'))

    command.execute(directory: 'some/.terraform')
  end
end
