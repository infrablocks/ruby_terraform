require 'spec_helper'

describe RubyTerraform::Options::Standard do
  let(:switch) { '-switch' }
  let(:value) { 'some/state.tfstate' }
  let(:builder) { instance_double(Lino::CommandLineBuilder) }
  let(:apply) { option.apply(builder) }

  subject(:option) { described_class.new(switch, value) }

  before do
    allow(JSON).to receive(:generate).and_call_original
    allow(builder).to receive(:with_repeated_option).and_return(builder)
    allow(builder).to receive(:with_option).and_return(builder)
    apply
  end

  describe '#apply' do
    it 'returns the altered subcommand' do
      expect(apply).to eq(builder)
    end

    context 'when the options value is a single value' do
      context 'when the options does not contain boolean values' do
        context 'when the options value is populated / true' do
          let(:value) { true }

          it 'calls the SubcommandBuilder with_option with the switch and value' do
            expect(builder).to have_received(:with_option).with(switch, value)
          end
        end

        context 'when the options value is false' do
          let(:value) { false }

          it 'does not call the SubcommandBuilder with_option' do
            expect(builder).not_to have_received(:with_repeated_option)
          end
        end

        context 'when the options value is nil' do
          let(:value) { nil }

          it 'does not call the SubcommandBuilder with_option' do
            expect(builder).not_to have_received(:with_repeated_option)
          end
        end
      end
    end

    context 'when the options value responds to keys' do
      let(:value) { { key: 'value', another: 'value' } }

      it 'calls the SubcommandBuilder with_repeated_option with the switch and an array key value pairs' do
        expect(builder).to have_received(:with_repeated_option).with(
          switch, %w['key=value' 'another=value'], anything # rubocop:disable Lint/PercentStringArray
        )
      end

      it 'specifies the separator is a single space' do
        expect(builder).to have_received(:with_repeated_option).with(
          anything, anything, { separator: ' ' }
        )
      end

      context 'when the values within the options value are not strings' do
        let(:value) { { key: 123 } }

        it 'uses JSON.generate to convert the value to a string' do
          expect(JSON).to have_received(:generate).with(123)
        end

        it 'calls the SubcommandBuilder with_repeated_option with the switch and the converted value' do
          expect(builder).to have_received(:with_repeated_option).with(
            switch, ["'key=123'"], anything
          )
        end
      end
    end

    context 'when the options value responds to each' do
      let(:value) { %w[some/state.tfstate another/state.tfstate] }

      it 'calls the SubcommandBuilder with_repeated_option withthe switch and the array value' do
        expect(builder).to have_received(:with_repeated_option).with(
          switch,
          %w[some/state.tfstate another/state.tfstate]
        )
      end
    end
  end
end
