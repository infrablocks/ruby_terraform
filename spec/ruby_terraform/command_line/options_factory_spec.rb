require 'spec_helper'
require_relative '../../../lib/ruby_terraform/command_line/options_factory'
require_relative '../../../lib/ruby_terraform/command_line/option/standard'
require_relative '../../../lib/ruby_terraform/command_line/option/flag'
require_relative '../../../lib/ruby_terraform/command_line/option/boolean'

module RubyTerraform
  module CommandLine
    describe OptionsFactory do
      subject(:options) do
        described_class.from(
          values,
          test_data.map { |_k, v| v[:switch] }.uniq
        )
      end
      let(:test_data) do
        { my_standard: { switch: '-my-standard', value: 'standard value',
                         class: Option::Standard, option: standard },
          my_boolean: { switch: '-my-boolean', value: true,
                        class: Option::Boolean, option: boolean },
          my_flag: { switch: '-my-flag', value: false,
                     class: Option::Flag, option: flag },
          my_plural: { switch: '-my-plural', value: 'value1',
                       class: Option::Standard, option: singular },
          my_plurals: { switch: '-my-plural', value: %w[value2 value3],
                        class: Option::Standard, option: plural },
          override: { switch: '-override', value: 'overridden value',
                      class: Option::Standard, option: override } }
      end
      let(:values) do
        values = test_data.transform_values { |v| v[:value] }
        values[:option_key] = values.delete(:override)
        values
      end
      let(:standard) { instance_double(Option::Standard) }
      let(:flag) { instance_double(Option::Flag) }
      let(:boolean) { instance_double(Option::Boolean) }
      let(:singular) { instance_double(Option::Standard) }
      let(:override) { instance_double(Option::Standard) }
      let(:plural) { instance_double(Option::Standard) }

      before do
        stub_options(test_data)
        stub_const(
          'RubyTerraform::CommandLine::OptionsFactory::PLURAL_SWITCHES',
          Set.new(['-my-plural'])
        )
        stub_const(
          'RubyTerraform::CommandLine::OptionsFactory::BOOLEAN_SWITCHES',
          Set.new(['-my-boolean'])
        )
        stub_const(
          'RubyTerraform::CommandLine::OptionsFactory::FLAG_SWITCHES',
          Set.new(['-my-flag'])
        )
        stub_const(
          'RubyTerraform::CommandLine::OptionsFactory::OVERRIDE_SWITCHES',
          { override: :option_key }
        )
        options
      end

      describe '.from' do
        it 'creates a Standard Option with the singular switch and singular value for each plural option' do
          expect(Option::Standard).to have_received(:new).with(
            test_data[:my_plural][:switch], test_data[:my_plural][:value]
          )
        end

        it 'creates a Standard Option with the singular switch and plural value for each plural option' do
          expect(Option::Standard).to have_received(:new).with(
            test_data[:my_plurals][:switch], test_data[:my_plurals][:value]
          )
        end

        it 'creates a Boolean Option for each boolean switch' do
          expect(Option::Boolean).to have_received(:new).with(
            test_data[:my_boolean][:switch], test_data[:my_boolean][:value]
          )
        end

        it 'creates a Flag Option each flag switch' do
          expect(Option::Flag).to have_received(:new).with(
            test_data[:my_flag][:switch], test_data[:my_flag][:value]
          )
        end

        it 'uses the overridden option value when creating an overridden switch' do
          expect(Option::Standard).to have_received(:new).with(
            test_data[:override][:switch], test_data[:override][:value]
          )
        end

        it 'creates a Standard Option for any other switches' do
          expect(Option::Standard).to have_received(:new).with(
            test_data[:my_standard][:switch], test_data[:my_standard][:value]
          )
        end

        it 'returns the array of Options' do
          expect(options).to eq([standard, boolean, flag, singular, plural, override])
        end
      end

      def stub_options(test_data)
        test_data.each_value do |config|
          stub_option(
            config[:class], config[:switch], config[:value], config[:option]
          )
        end
      end

      def stub_option(clazz, key, value, return_val)
        allow(clazz).to receive(:new).with(key, value).and_return(return_val)
      end
    end
  end
end
