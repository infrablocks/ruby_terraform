require 'spec_helper'

describe RubyTerraform::Commands::Output do
  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  it 'calls the terraform get command passing the supplied directory' do
    command = RubyTerraform::Commands::Output.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with('terraform output', any_args))

    command.execute
  end

  it 'defaults to the configured binary when none provided' do
    command = RubyTerraform::Commands::Output.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary output', any_args))

    command.execute(directory: 'some/path/to/terraform/configuration')
  end

  it 'adds a state option if a state path is provided' do
    command = RubyTerraform::Commands::Output.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform output -state=some/state.tfstate", any_args))

    command.execute(state: 'some/state.tfstate')
  end

  it 'passes the provided output name if supplied' do
    command = RubyTerraform::Commands::Output.new(binary: 'terraform')

    expect(Open4).to(
        receive(:spawn)
            .with("terraform output important_output", any_args))

    command.execute(name: 'important_output')
  end

  it 'passes the provided module name if supplied' do
    command = RubyTerraform::Commands::Output.new(binary: 'terraform')

    expect(Open4).to(
      receive(:spawn)
          .with("terraform output -module=some_module", any_args))

    command.execute(module: 'some_module')
  end

  it 'captures and returns the output of the command directly when no name is supplied' do
    string_io = double('string IO')
    allow(StringIO).to(receive(:new).and_return(string_io))
    allow(string_io).to(receive(:string).and_return('  OUTPUT  '))

    command = RubyTerraform::Commands::Output.new(binary: 'terraform')

    expect(Open4)
        .to(receive(:spawn)
                .with(instance_of(String), hash_including(stdout: string_io)))

    expect(command.execute).to(eq('  OUTPUT  '))
  end

  it 'captures, chomps and returns the output of the command when an output name is supplied' do
    string_io = double('string IO')
    allow(StringIO).to(receive(:new).and_return(string_io))
    allow(string_io).to(receive(:string).and_return("OUTPUT\n"))

    command = RubyTerraform::Commands::Output.new(binary: 'terraform')

    expect(Open4)
        .to(receive(:spawn)
                .with(instance_of(String), hash_including(stdout: string_io)))

    expect(command.execute(name: 'some_output')).to(eq('OUTPUT'))
  end

  it 'includes the no-color flag when the no_color option is true' do
    command = RubyTerraform::Commands::Output.new

    expect(Open4).to(
        receive(:spawn)
            .with('path/to/binary output -no-color', any_args))

    command.execute(no_color: true)
  end
end
