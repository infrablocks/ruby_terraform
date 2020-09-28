# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Output do
  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
    allow(Open4).to receive(:spawn)
  end

  after do
    RubyTerraform.reset!
  end

  it 'calls the terraform get command passing the supplied directory' do
    command = described_class.new(binary: 'terraform')

    command.execute

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform output', any_args)
    )
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute(directory: 'some/path/to/terraform/configuration')

    expect(Open4).to(
      have_received(:spawn)
          .with('path/to/binary output', any_args)
    )
  end

  it 'adds a state option if a state path is provided' do
    command = described_class.new(binary: 'terraform')

    command.execute(state: 'some/state.tfstate')

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform output -state=some/state.tfstate', any_args)
    )
  end

  it 'passes the provided output name if supplied' do
    command = described_class.new(binary: 'terraform')

    command.execute(name: 'important_output')

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform output important_output', any_args)
    )
  end

  it 'passes the provided module name if supplied' do
    command = described_class.new(binary: 'terraform')

    command.execute(module: 'some_module')

    expect(Open4).to(
      have_received(:spawn)
          .with('terraform output -module=some_module', any_args)
    )
  end

  it 'captures and returns the output of the command directly when ' \
     'no name is supplied' do
    string_io = StringIO.new
    allow(StringIO).to(receive(:new).and_return(string_io))
    allow(string_io).to(receive(:string).and_return('  OUTPUT  '))

    command = described_class.new(binary: 'terraform')

    expect(command.execute).to(eq('  OUTPUT  '))

    expect(Open4).to(
      have_received(:spawn)
        .with(instance_of(String), hash_including(stdout: string_io))
    )
  end

  it 'captures, chomps and returns the output of the command when ' \
     'an output name is supplied' do
    string_io = StringIO.new
    allow(StringIO).to(receive(:new).and_return(string_io))
    allow(string_io).to(receive(:string).and_return("OUTPUT\n"))

    command = described_class.new(binary: 'terraform')

    expect(command.execute(name: 'some_output')).to(eq('OUTPUT'))

    expect(Open4).to(
      have_received(:spawn)
        .with(instance_of(String), hash_including(stdout: string_io))
    )
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = described_class.new

    command.execute(no_color: true)

    expect(Open4).to(
      have_received(:spawn)
          .with('path/to/binary output -no-color', any_args)
    )
  end

  it 'includes the json flag when the json option is true' do
    command = described_class.new

    command.execute(json: true)

    expect(Open4).to(
      have_received(:spawn)
          .with('path/to/binary output -json', any_args)
    )
  end
end
