require 'spec_helper'
require_relative '../../../lib/ruby_terraform/command_line/option'

module RubyTerraform
  module CommandLine
    describe Option do
      subject(:command_line_option) { described_class.new(opt_key, value, options) }

      let(:opt_key) { :snake_key }
      let(:value) { 'some/state.tfstate' }
      let(:options) { {} }
      let(:sub) { instance_double(Lino::SubcommandBuilder) }
      let(:add_to_subcommand) { command_line_option.add_to_subcommand(sub) }

      before do
        allow(JSON).to receive(:generate).and_call_original
        allow(sub).to receive(:with_option).and_return(sub)
        add_to_subcommand
      end

      describe '.new' do
        it_behaves_like 'an option that derives the command switch'
      end

      describe '#add_to_subcommand' do
        it 'returns the altered subcommand' do
          expect(add_to_subcommand).to eq(sub)
        end

        context 'when the option value is a single value' do
          context 'when the option does not contain boolean values' do
            context 'when the option value is populated / true' do
              let(:value) { true }

              it 'calls the SubcommandBuilder with_option with the switch and value' do
                expect(sub).to have_received(:with_option).with('-snake-key', value)
              end
            end

            context 'when the option value is false' do
              let(:value) { false }

              it 'does not call the SubcommandBuilder with_option' do
                expect(sub).not_to have_received(:with_option)
              end
            end

            context 'when the option value is nil' do
              let(:value) { nil }

              it 'does not call the SubcommandBuilder with_option' do
                expect(sub).not_to have_received(:with_option)
              end
            end
          end
        end

        context 'when the option value responds to keys' do
          let(:value) { { key: 'value', another: 'value' } }

          it 'calls the SubcommandBuilder with_option for each key value pair' do
            expect(sub).to have_received(:with_option).with('-snake-key', "'key=value'", anything)
            expect(sub).to have_received(:with_option).with('-snake-key', "'another=value'", anything)
          end

          it 'specifies the separator is a single space' do
            expect(sub).to have_received(:with_option).with(anything, anything, { separator: ' ' }).twice
          end

          context 'when the values within the option value are not strings' do
            let(:value) { { key: 123 } }

            it 'uses JSON.generate to convert the value to a string' do
              expect(JSON).to have_received(:generate).with(123)
            end

            it 'calls the SubcommandBuilder with_option with the converted value' do
              expect(sub).to have_received(:with_option).with('-snake-key', "'key=123'", anything)
            end
          end
        end

        context 'when the option value responds to each' do
          let(:value) { %w[some/state.tfstate another/state.tfstate] }

          it 'calls the SubcommandBuilder with_option for each value' do
            expect(sub).to have_received(:with_option).with('-snake-key', 'some/state.tfstate')
            expect(sub).to have_received(:with_option).with('-snake-key', 'another/state.tfstate')
          end
        end
      end
    end
  end
end
