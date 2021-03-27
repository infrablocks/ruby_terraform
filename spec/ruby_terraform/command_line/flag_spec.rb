require 'spec_helper'
require_relative '../../../lib/ruby_terraform/command_line/flag'

module RubyTerraform
  module CommandLine
    describe Flag do
      subject(:command_line_option) { described_class.new(opt_key, value, options) }

      let(:opt_key) { :snake_key }
      let(:value) { true }
      let(:options) { {} }
      let(:sub) { instance_double(Lino::SubcommandBuilder) }
      let(:add_to_subcommand) { command_line_option.add_to_subcommand(sub) }

      before do
        allow(sub).to receive(:with_flag).and_return(sub)
        add_to_subcommand
      end

      describe '.new' do
        it_behaves_like 'an option that derives the command switch'

        it_behaves_like 'an option that converts its value to a boolean'
      end

      describe '#add_to_subcommand' do
        context 'when the option value is true' do
          it 'adds the switch to the terraform command line' do
            expect(sub).to have_received(:with_flag).with('-snake-key',)
          end

          context 'when the option value is false' do
            let(:value) { false }

            it 'does not add the switch to the terraform command line' do
              expect(sub).not_to have_received(:with_flag)
            end
          end

          context 'when the option value is nil' do
            let(:value) { nil }

            it 'does not add the switch to the terraform command line' do
              expect(sub).not_to have_received(:with_flag)
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
