require 'spec_helper'
require_relative '../../../../lib/ruby_terraform/command_line/option/boolean'

module RubyTerraform
  module CommandLine
    module Option
      describe Boolean do
        subject(:option) { described_class.new(switch, value) }

        let(:switch) { '-switch' }
        let(:value) { true }
        let(:sub) { instance_double(Lino::SubcommandBuilder) }
        let(:add_to_subcommand) { option.add_to_subcommand(sub) }

        before do
          allow(sub).to receive(:with_option).and_return(sub)
          add_to_subcommand
        end

        describe '.new' do
          it_behaves_like 'an option that converts its value to a boolean'
        end

        describe '#add_to_subcommand' do
          context 'when the option value is true' do
            it 'adds the option=true to the terraform command line' do
              expect(sub).to have_received(:with_option).with(switch, true)
            end

            context 'when the option value is false' do
              let(:value) { false }

              it 'adds the option=false to the terraform command line' do
                expect(sub).to have_received(:with_option).with(switch, false)
              end
            end

            context 'when the option value is nil' do
              let(:value) { nil }

              it 'calls with_option with the option key and value (where it is ignored)' do
                expect(sub).to have_received(:with_option).with(switch, nil)
              end
            end

            it 'returns the altered subcommand' do
              expect(add_to_subcommand).to eq(sub)
            end
          end
        end
      end
    end
  end
end
