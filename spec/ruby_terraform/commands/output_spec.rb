# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
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

  shared_examples 'it supports output naming' do
    it 'captures and returns the output of the command directly' do
      expect(execute).to(eq(string_output))
    end

    context 'when an output name is supplied' do
      let(:exec_parameters) { { name: 'some_output' } }

      it 'captures, chomps and returns the output of the command' do
        expect(execute).to(eq('  OUTPUT  '))
      end
    end
  end

  describe 'output handling' do
    let(:string_io) { instance_double(StringIO, string: string_output) }
    let(:string_output) { "  OUTPUT  \n" }
    let(:executor) { Lino::Executors::Mock.new }
    let(:execute) { command.execute(exec_parameters) }
    let(:exec_parameters) { {} }

    before do
      Lino.configure do |config|
        config.executor = executor
      end
      allow(StringIO).to receive(:new).and_return(string_io)
      execute
    end

    after do
      Lino.reset!
    end

    context 'when no stdout is supplied' do
      it 'creates a new StringIO instance' do
        expect(StringIO).to have_received(:new)
      end

      it 'supplies the StringIO instance as the stdout when running ' \
         'the command' do
        expect(executor.calls.first)
          .to(satisfy { |call| call[:opts][:stdout] == string_io })
      end
    end

    it_behaves_like('it supports output naming')

    context 'when a stdout option is supplied' do
      let(:parameters) { { binary: 'terraform', stdout: dummy_stdout } }
      let(:dummy_stdout) { instance_double(StringIO, string: string_output) }

      it 'does not create a new StringIO instance' do
        expect(StringIO).not_to have_received(:new)
      end

      it 'passes the stdout option as the stdout when running ' \
         'the command' do
        expect(executor.calls.first)
          .to(satisfy { |call| call[:opts][:stdout] == dummy_stdout })
      end

      it_behaves_like('it supports output naming')
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
# rubocop:enable RSpec/MultipleMemoizedHelpers
