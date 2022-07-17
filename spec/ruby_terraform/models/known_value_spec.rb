# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::KnownValue do
  describe '#value' do
    it 'returns the underlying value' do
      known_value = described_class.new('some-value')

      expect(known_value.value).to(eq('some-value'))
    end
  end

  describe '#unbox' do
    it 'returns the underlying value' do
      known_value = described_class.new('some-value')

      expect(known_value.unbox).to(eq('some-value'))
    end
  end

  describe '#known?' do
    it 'returns true' do
      known_value = described_class.new('some-value')

      expect(known_value).to(be_known)
    end
  end

  describe '#sensitive?' do
    it 'returns true when sensitive' do
      known_value = described_class.new('some-value', sensitive: true)

      expect(known_value).to(be_sensitive)
    end

    it 'returns false when not sensitive' do
      known_value = described_class.new('some-value', sensitive: false)

      expect(known_value).not_to(be_sensitive)
    end

    it 'returns false by default' do
      known_value = described_class.new('some-value')

      expect(known_value).not_to(be_sensitive)
    end
  end

  describe '#==' do
    it 'returns true when the state and class are the same' do
      value1 = described_class.new('some-value')
      value2 = described_class.new('some-value')

      expect(value1).to(eq(value2))
    end

    it 'returns false when the value is different' do
      value1 = described_class.new('first-value')
      value2 = described_class.new('second-value')

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when sensitive is different' do
      value1 = described_class.new('some-value', sensitive: true)
      value2 = described_class.new('some-value', sensitive: false)

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when the classes are different' do
      value1 = described_class.new('some-value', sensitive: true)
      value2 = Class.new(described_class)
                    .new('some-value', sensitive: true)

      expect(value1).not_to(eq(value2))
    end
  end

  describe '#hash' do
    it 'has the same result when the state and class are the same' do
      value1 = described_class.new('some-value')
      value2 = described_class.new('some-value')

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has a different result when the value is different' do
      value1 = described_class.new('first-value')
      value2 = described_class.new('second-value')

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when sensitive is different' do
      value1 = described_class.new('some-value', sensitive: true)
      value2 = described_class.new('some-value', sensitive: false)

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when the classes are different' do
      value1 = described_class.new('some-value', sensitive: true)
      value2 = Class.new(described_class).new('some-value', sensitive: true)

      expect(value1.hash).not_to(eq(value2.hash))
    end
  end

  describe '#inspect' do
    it 'returns the underlying value with known and non-sensitive ' \
       'by default' do
      known_value = described_class.new('some-value')

      expect(known_value.inspect)
        .to(eq('"some-value" (known, non-sensitive)'))
    end

    it 'returns the underlying value with known and non-sensitive when ' \
       'not sensitive' do
      known_value = described_class.new('some-value', sensitive: false)

      expect(known_value.inspect)
        .to(eq('"some-value" (known, non-sensitive)'))
    end

    it 'returns the underlying value with known and sensitive when ' \
       'sensitive' do
      known_value = described_class.new('some-value', sensitive: true)

      expect(known_value.inspect).to(eq('"some-value" (known, sensitive)'))
    end
  end
end
