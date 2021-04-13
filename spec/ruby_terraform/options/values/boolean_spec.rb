# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

describe RubyTerraform::Options::Values::Boolean do
  describe '#resolve' do
    it 'returns true when passed boolean true' do
      expect(described_class.new(true).resolve)
        .to(eq(true))
    end

    it 'returns true when passed string true' do
      expect(described_class.new('true').resolve)
        .to(eq(true))
    end

    it 'returns false when passed boolean false' do
      expect(described_class.new(false).resolve)
        .to(eq(false))
    end

    it 'returns false when passed string false' do
      expect(described_class.new('false').resolve)
        .to(eq(false))
    end

    it 'returns false when passed unrecognised string' do
      random_string = SecureRandom.hex
      expect(described_class.new(random_string).resolve)
        .to(eq(false))
    end

    it 'returns nil when passed nil' do
      expect(described_class.new(nil).resolve)
        .to(eq(nil))
    end
  end

  describe '#render' do
    it 'returns "true" when passed boolean true' do
      expect(described_class.new(true).render)
        .to(eq('true'))
    end

    it 'returns "true" when passed string true' do
      expect(described_class.new('true').render)
        .to(eq('true'))
    end

    it 'returns "false" when passed boolean false' do
      expect(described_class.new(false).render)
        .to(eq('false'))
    end

    it 'returns "false" when passed string false' do
      expect(described_class.new('false').render)
        .to(eq('false'))
    end

    it 'returns "false" when passed unrecognised string' do
      random_string = SecureRandom.hex
      expect(described_class.new(random_string).render)
        .to(eq('false'))
    end

    it 'returns nil when passed nil' do
      expect(described_class.new(nil).render)
        .to(eq(nil))
    end
  end
end
