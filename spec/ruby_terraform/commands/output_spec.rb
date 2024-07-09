# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Commands::Output do
  let(:parameters) { { binary: 'terraform' } }
  let(:command) { described_class.new(parameters) }

  before do
    RubyTerraform.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyTerraform.reset!
  end

  describe 'output handling' do
    let(:executor) { Lino::Executors::Mock.new }

    before do
      Lino.configure do |config|
        config.executor = executor
      end
    end

    after do
      Lino.reset!
    end

    context 'when no output name is supplied' do
      it 'captures and returns output' do
        executor.write_to_stdout("  OUTPUT  \n")

        expect(command.execute).to(eq("  OUTPUT  \n"))
      end
    end

    context 'when an output name is supplied' do
      it 'captures, chomps and returns the output of the command' do
        executor.write_to_stdout("  OUTPUT  \n")

        expect(command.execute(name: 'some_output')).to(eq('  OUTPUT  '))
      end
    end
  end

  it_behaves_like(
    'a command with an argument',
    described_class, 'output', :name
  )

  it_behaves_like(
    'a command without a binary supplied',
    described_class, 'output'
  )

  it_behaves_like(
    'a command with an option',
    described_class, 'output', :state
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'output', :no_color
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'output', :json
  )

  it_behaves_like(
    'a command with a flag',
    described_class, 'output', :raw
  )

  it_behaves_like(
    'a command with global options',
    described_class, 'output'
  )
end
