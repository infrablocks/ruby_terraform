require 'spec_helper'

require_relative '../../../lib/ruby_terraform/options/boolean'

describe RubyTerraform::Options::Boolean do
  let(:switch) { '-switch' }
  let(:value) { true }
  let(:builder) { instance_double(Lino::CommandLineBuilder) }
  let(:apply) { option.apply(builder) }

  subject(:option) { described_class.new(switch, value) }

  before do
    allow(builder).to receive(:with_option).and_return(builder)
    apply
  end

  describe '.new' do
    it_behaves_like 'an option that converts its value to a boolean'
  end

  describe '#add_to_subcommand' do
    context 'when the options value is true' do
      it 'adds the options=true to the terraform command line' do
        expect(builder).to have_received(:with_option).with(switch, true)
      end

      context 'when the options value is false' do
        let(:value) { false }

        it 'adds the options=false to the terraform command line' do
          expect(builder).to have_received(:with_option).with(switch, false)
        end
      end

      context 'when the options value is nil' do
        let(:value) { nil }

        it 'calls with_option with the options key and value (where it is ignored)' do
          expect(builder).to have_received(:with_option).with(switch, nil)
        end
      end

      it 'returns the altered subcommand' do
        expect(apply).to eq(builder)
      end
    end
  end
end
