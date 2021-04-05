require 'spec_helper'

describe RubyTerraform::Options::Flag do
  subject(:option) { described_class.new(switch, value) }

  let(:switch) { '-switch' }
  let(:value) { true }
  let(:builder) { instance_double(Lino::CommandLineBuilder) }
  let(:apply) { option.apply(builder) }

  before do
    allow(builder).to receive(:with_flag).and_return(builder)
    apply
  end

  describe '.new' do
    it_behaves_like 'an option that converts its value to a boolean'
  end

  describe '#add_to_subcommand' do
    context 'when the options value is true' do
      it 'adds the switch to the terraform command line' do
        expect(builder).to have_received(:with_flag).with(switch)
      end

      context 'when the options value is false' do
        let(:value) { false }

        it 'does not add the switch to the terraform command line' do
          expect(builder).not_to have_received(:with_flag)
        end
      end

      context 'when the options value is nil' do
        let(:value) { nil }

        it 'does not add the switch to the terraform command line' do
          expect(builder).not_to have_received(:with_flag)
        end
      end

      it 'returns the altered subcommand' do
        expect(apply).to eq(builder)
      end
    end
  end
end
