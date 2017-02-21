require 'spec_helper'

describe RubyTerraform::Commands::Clean do
  it 'deletes the .terraform directory in the current directory' do
    command = RubyTerraform::Commands::Clean.new

    expect(FileUtils).to(
        receive(:rm_rf).with('.terraform'))

    command.execute
  end

  it 'uses the provided base directory when supplied' do
    command = RubyTerraform::Commands::Clean.new(base_directory: 'some/path')

    expect(FileUtils).to(
        receive(:rm_rf).with('some/path/.terraform'))

    command.execute
  end

  it 'allows the directory to be overridden on execution' do
    command = RubyTerraform::Commands::Clean.new

    expect(FileUtils).to(
        receive(:rm_rf).with('some/.terraform'))

    command.execute(directory: 'some/.terraform')
  end
end
