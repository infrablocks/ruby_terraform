require 'spec_helper'
require_relative '../../../lib/ruby_terraform/command_line/options'
require_relative '../../../lib/ruby_terraform/command_line/option'
require_relative '../../../lib/ruby_terraform/command_line/flag'
require_relative '../../../lib/ruby_terraform/command_line/boolean_option'

module RubyTerraform
  module CommandLine
    describe Options do
      subject(:command_line_options) do
        described_class.new(
          option_values: option_values,
          command_arguments: {
            standard: %i[my_option],
            boolean: %i[my_boolean],
            flags: %i[my_flag],
            switch_overrides: { my_override: switch_override }
          }
        )
      end

      let(:option_values) do
        {
          my_option: my_option_value,
          my_flag: my_flag_value,
          my_boolean: my_boolean_value,
          my_override: my_override_value
        }
      end
      let(:my_option_value) { 'value' }
      let(:my_flag_value) { true }
      let(:my_boolean_value) { true }
      let(:my_override_value) { 'value' }
      let(:switch_override) { '-different-switch' }
      let(:command_line_option) { instance_double(Option) }
      let(:command_line_override) { instance_double(Option) }
      let(:command_line_flag) { instance_double(Flag) }
      let(:command_line_boolean) { instance_double(BooleanOption) }

      before do
        allow(Option).to receive(:new).with(:my_option, any_args).and_return(command_line_option)
        allow(Flag).to receive(:new).with(:my_flag, any_args).and_return(command_line_flag)
        allow(BooleanOption).to receive(:new).with(:my_boolean, any_args).and_return(command_line_boolean)
        allow(Option).to receive(:new).with(:my_override, any_args).and_return(command_line_override)
        command_line_options
      end

      describe '.new' do
        it 'creates a CommandLineOption with an overridden switch for each switch_overrides' do
          expect(Option).to have_received(:new).with(:my_override, my_override_value, switch_override: switch_override)
        end

        it 'creates a CommandLineOption option for each standard option' do
          expect(Option).to have_received(:new).with(:my_option, my_option_value, switch_override: nil)
        end

        it 'creates a Flag for each flag option' do
          expect(Flag).to have_received(:new).with(:my_flag, my_flag_value)
        end

        it 'creates a BooleanOption for each boolean option' do
          expect(BooleanOption).to have_received(:new).with(:my_boolean, my_boolean_value)
        end

        it 'populates the array with the created command line options' do
          expect(command_line_options).to eq([command_line_override, command_line_option, command_line_boolean, command_line_flag])
        end
      end
    end
  end
end
