require 'spec_helper'

describe RubyTerraform::Configuration do
  before(:each) do
    allow(File).to receive(:open).with('file.log', 'a').and_return(File)
  end

  after(:all) do
    RubyTerraform.configuration.logger = RubyTerraform::Configuration.new.logger
  end

  it 'Logger stream should have a default configuration' do
    expect(RubyTerraform.configuration.logger.class).to eq(Logger)
  end

  it 'Logger should have level INFO as default logger level' do
    expect(RubyTerraform.configuration.logger.level).to eq(1)
  end

  it 'Logger should be configurable' do
    RubyTerraform.configure do |config|
      config.logger = File.open('file.log', 'a')
    end

    expect(RubyTerraform.configuration.logger).to eq(File)
  end

  it 'Binary should have a default configuration' do
    expect(RubyTerraform.configuration.binary).to eq('terraform')
  end

  it 'STDOUT stream should have a default configuration' do
    expect(RubyTerraform.configuration.stdout).to eq($stdout)
  end

  it 'STDERR stream should have a default configuration' do
    expect(RubyTerraform.configuration.stderr).to eq($stderr)
  end

  it 'STDIN stream should have a default configuration' do
    expect(RubyTerraform.configuration.stdin).to eq('')
  end

  it 'STDOUT stream should be configurable' do
    RubyTerraform.configure do |config|
      config.stdout = File.open('file.log', 'a')
    end

    expect(RubyTerraform.configuration.stdout).to eq(File)
  end

  it 'STDERR stream should be configurable' do
    RubyTerraform.configure do |config|
      config.stderr = File.open('file.log', 'a')
    end

    expect(RubyTerraform.configuration.stderr).to eq(File)
  end

end
