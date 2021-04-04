require 'spec_helper'
require_relative '../../../../lib/ruby_terraform/command_line/option/base'

module RubyTerraform
  module CommandLine
    module Option
      describe Base do
        subject(:option) { described_class.new(switch, value) }

        let(:switch) { '-switch' }
        let(:value) { 'option value' }
        let(:sub) { instance_double(Lino::SubcommandBuilder) }

        describe '.new' do
          it 'uses a method to assign the option value to allow value setting to be overridden' do
            expect(option.instance_variable_get(:@value)).to eq(value)
          end
        end

        describe '#add_to_subcommand' do
          it 'raises an error to inform subclasses of the need to override the method' do
            expect { option.add_to_subcommand(sub) }.to raise_error(StandardError, 'not implemented')
          end
        end
      end
    end
  end
end
