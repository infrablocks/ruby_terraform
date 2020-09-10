# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Format do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform fmt command passing the supplied directory' do
    command = RubyTerraform::Commands::Format.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform fmt some/path/to/terraform/configuration', any_args)
    )

    command.execute(
        directory: 'some/path/to/terraform/configuration'
    )
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Format.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary fmt some/path/to/terraform/configuration', any_args)
    )

    command.execute(
        directory: 'some/path/to/terraform/configuration',
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Format.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform fmt -no-color some/path/to/terraform/configuration', any_args)
    )

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        no_color: true
    )
  end

  it 'includes the check flag when the check option is true' do
    command = RubyTerraform::Commands::Format.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform fmt -check some/path/to/terraform/configuration', any_args)
    )

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        check: true
    )
  end

  it 'includes the diff flag when the diff option is true' do
    command = RubyTerraform::Commands::Format.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform fmt -diff some/path/to/terraform/configuration', any_args)
    )

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        diff: true
    )
  end

  it 'includes the list flag when the list option is true' do
    command = RubyTerraform::Commands::Format.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform fmt -list=true some/path/to/terraform/configuration', any_args)
    )

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        list: true
    )
  end

  it 'includes the recursive flag when the recursive option is true' do
    command = RubyTerraform::Commands::Format.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform fmt -recursive some/path/to/terraform/configuration', any_args)
    )

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        recursive: true
    )
  end

  it 'includes the write flag when the write option is true' do
    command = RubyTerraform::Commands::Format.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform fmt -write=true some/path/to/terraform/configuration', any_args)
    )

    command.execute(
        directory: 'some/path/to/terraform/configuration',
        write: true
    )
  end

end
