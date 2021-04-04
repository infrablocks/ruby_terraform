# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Options::Factory do
  subject(:options) do
    described_class.from(
      test_data.map { |_k, v| v[:switch] }.uniq,
      values
    )
  end

  let(:test_data) do # rubocop:disable Metrics/BlockLength
    {
      my_standard: {
        switch: '-my-standard',
        value: 'standard value',
        class: RubyTerraform::Options::Types::Standard,
        option: standard
      },
      my_boolean: {
        switch: '-my-boolean',
        value: true,
        class: RubyTerraform::Options::Types::Boolean,
        option: boolean
      },
      my_flag: {
        switch: '-my-flag',
        value: false,
        class: RubyTerraform::Options::Types::Flag,
        option: flag
      },
      my_plural: {
        switch: '-my-plural',
        value: 'value1',
        class: RubyTerraform::Options::Types::Standard,
        option: singular
      },
      my_plurals: {
        switch: '-my-plural',
        value: %w[value2 value3],
        class: RubyTerraform::Options::Types::Standard,
        option: plural
      },
      override: {
        switch: '-override',
        value: 'overridden value',
        class: RubyTerraform::Options::Types::Standard,
        option: override
      }
    }
  end
  let(:values) do
    values = test_data.transform_values { |v| v[:value] }
    values[:option_key] = values.delete(:override)
    values
  end
  let(:standard) { instance_double(RubyTerraform::Options::Types::Standard) }
  let(:flag) { instance_double(RubyTerraform::Options::Types::Flag) }
  let(:boolean) { instance_double(RubyTerraform::Options::Types::Boolean) }
  let(:singular) { instance_double(RubyTerraform::Options::Types::Standard) }
  let(:override) { instance_double(RubyTerraform::Options::Types::Standard) }
  let(:plural) { instance_double(RubyTerraform::Options::Types::Standard) }

  before do
    stub_options(test_data)
    stub_const(
      'RubyTerraform::Options::Factory::PLURAL_OPTIONS',
      Set.new(['-my-plural'])
    )
    stub_const(
      'RubyTerraform::Options::Factory::BOOLEAN_OPTIONS',
      Set.new(['-my-boolean'])
    )
    stub_const(
      'RubyTerraform::Options::Factory::FLAG_OPTIONS',
      Set.new(['-my-flag'])
    )
    stub_const(
      'RubyTerraform::Options::Factory::OVERRIDE_OPTIONS',
      { override: :option_key }
    )
    options
  end

  describe '.from' do
    it 'creates a Standard Option with the singular switch and singular ' \
       'value for each plural options' do
      expect(RubyTerraform::Options::Types::Standard)
        .to(have_received(:new)
              .with(
                test_data[:my_plural][:switch],
                test_data[:my_plural][:value]
              ))
    end

    it 'creates a Standard Option with the singular switch and plural ' \
       'value for each plural options' do
      expect(RubyTerraform::Options::Types::Standard)
        .to(have_received(:new)
              .with(
                test_data[:my_plurals][:switch],
                test_data[:my_plurals][:value]
              ))
    end

    it 'creates a Boolean Option for each boolean switch' do
      expect(RubyTerraform::Options::Types::Boolean)
        .to(have_received(:new)
              .with(
                test_data[:my_boolean][:switch],
                test_data[:my_boolean][:value]
              ))
    end

    it 'creates a Flag Option each flag switch' do
      expect(RubyTerraform::Options::Types::Flag)
        .to(have_received(:new)
              .with(
                test_data[:my_flag][:switch],
                test_data[:my_flag][:value]
              ))
    end

    it 'uses the overridden options value when creating an ' \
       'overridden switch' do
      expect(RubyTerraform::Options::Types::Standard)
        .to(have_received(:new)
              .with(
                test_data[:override][:switch],
                test_data[:override][:value]
              ))
    end

    it 'creates a Standard Option for any other switches' do
      expect(RubyTerraform::Options::Types::Standard)
        .to(have_received(:new)
              .with(
                test_data[:my_standard][:switch],
                test_data[:my_standard][:value]
              ))
    end

    it 'returns the array of Options' do
      expect(options).to eq([standard, boolean, flag, singular, plural,
                             override])
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
