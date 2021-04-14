# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Options::Values do
  describe '.boolean' do
    it 'builds a boolean value' do
      expect(RubyTerraform::Options::Values.boolean('true'))
        .to(eq(RubyTerraform::Options::Values::Boolean.new('true')))
    end
  end

  describe '.string' do
    it 'builds a string value' do
      expect(RubyTerraform::Options::Values.string('/some/path'))
        .to(eq(RubyTerraform::Options::Values::String.new('/some/path')))
    end
  end

  describe '.complex' do
    it 'builds a complex value' do
      expect(RubyTerraform::Options::Values.complex([1, 2, 3]))
        .to(eq(RubyTerraform::Options::Values::Complex.new([1, 2, 3])))
    end
  end

  describe '.key_value' do
    it 'builds a key value value' do
      expect(RubyTerraform::Options::Values.key_value('thing', [1, 2, 3]))
        .to(eq(RubyTerraform::Options::Values::KeyValue.new(
                 'thing', [1, 2, 3]
               )))
    end
  end

  describe '.resolve' do
    it 'returns Values::String for :string' do
      expect(RubyTerraform::Options::Values.resolve(:string))
        .to(eq(RubyTerraform::Options::Values::String))
    end

    it 'returns Values::Complex for :complex' do
      expect(RubyTerraform::Options::Values.resolve(:complex))
        .to(eq(RubyTerraform::Options::Values::Complex))
    end

    it 'returns Values::Boolean for :boolean' do
      expect(RubyTerraform::Options::Values.resolve(:boolean))
        .to(eq(RubyTerraform::Options::Values::Boolean))
    end

    it 'returns Values::KeyValue for :key_value' do
      expect(RubyTerraform::Options::Values.resolve(:key_value))
        .to(eq(RubyTerraform::Options::Values::KeyValue))
    end

    it 'returns provided value otherwise' do
      expect(RubyTerraform::Options::Values.resolve(Object))
        .to(eq(Object))
    end
  end
end
