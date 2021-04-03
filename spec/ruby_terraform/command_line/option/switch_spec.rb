require 'spec_helper'
require_relative '../../../../lib/ruby_terraform/command_line/option/switch'

module RubyTerraform
  module CommandLine
    module Option
      describe Switch do
        subject(:switch) { described_class.new(switch_string) }

        let(:switch_string) { '-switch-string' }

        describe '#to_s' do
          context 'when the switch string starts with a -' do
            it 'returns the supplied switch string' do
              expect(switch.to_s).to eq('-switch-string')
            end
          end

          context 'when the switch string does not start with a -' do
            let(:switch_string) { 'switch-string' }

            it 'returns the switch string prefixed with a -' do
              expect(switch.to_s).to eq('-switch-string')
            end
          end
        end

        describe '#as_key' do
          it 'returns the switch string converted to a hash key' do
            expect(switch.as_key).to eq(:switch_string)
          end
        end

        describe '#as_plural_key' do
          it 'returns the switch string suffixed with an s converted to a hash key' do
            expect(switch.as_plural_key).to eq(:switch_strings)
          end
        end

        describe '#==' do
          it 'returns true when compared to a string matching the switch_string' do
            expect(switch == '-switch-string').to be_truthy
          end

          it 'returns true when compared to a string not matching the switch_string' do
            expect(switch == '-different-switch').to be_falsey
          end
        end
      end
    end
  end
end
