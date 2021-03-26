require 'spec_helper'

describe RubyTerraform::Commands::Output do
  let(:command) { described_class.new(binary: 'terraform') }

  before(:each) do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyTerraform.reset!
  end

  terraform_command = 'output'

  it_behaves_like 'a command without a binary supplied', [terraform_command, described_class]

  it_behaves_like 'a command with an option', [terraform_command, :state]

  it_behaves_like 'a command with an argument', [terraform_command, :name]

  it_behaves_like 'a command with an option', [terraform_command, :module]

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

  it_behaves_like 'a command with a flag', [terraform_command, :no_color]

  it_behaves_like 'a command with a flag', [terraform_command, :json]
end
