require 'spec_helper'

describe RubyTerraform::Commands::Clean do
  before(:each) do
    RubyTerraform.configure do |config|
      @logger_mock = config.logger
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'deletes the .terraform directory in the current directory by default' do
    command = RubyTerraform::Commands::Clean.new

    expect(FileUtils).to(
        receive(:rm_r).with('.terraform', :secure => true))
    expect(@logger_mock).to(
      receive(:info).with('Cleaning terraform directory .terraform')
    )

    command.execute
  end

  it 'deletes the provided directory when specified' do
    command = RubyTerraform::Commands::Clean.new(directory: 'some/path')

    expect(FileUtils).to(
        receive(:rm_r).with('some/path', :secure => true))
    expect(@logger_mock).to(
      receive(:info).with('Cleaning terraform directory some/path')
    )

    command.execute
  end

  it 'allows the directory to be overridden on execution' do
    command = RubyTerraform::Commands::Clean.new

    expect(FileUtils).to(
        receive(:rm_r).with('some/.terraform', :secure => true))
    expect(@logger_mock).to(
      receive(:info).with('Cleaning terraform directory some/.terraform')
    )

    command.execute(directory: 'some/.terraform')
  end
end
