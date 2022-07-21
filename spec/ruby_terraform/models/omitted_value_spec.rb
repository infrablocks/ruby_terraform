# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::OmittedValue do
  describe '#value' do
    it 'returns nil' do
      known_value = described_class.new

      expect(known_value.value).to(be_nil)
    end
  end

  describe '#unbox' do
    it 'returns nil' do
      known_value = described_class.new

      expect(known_value.unbox).to(be_nil)
    end
  end

  describe '#known?' do
    it 'returns false' do
      unknown_value = described_class.new

      expect(unknown_value).not_to(be_known)
    end
  end

  describe '#sensitive?' do
    it 'returns true when sensitive' do
      unknown_value = described_class.new(sensitive: true)

      expect(unknown_value).to(be_sensitive)
    end

    it 'returns false when not sensitive' do
      unknown_value = described_class.new(sensitive: false)

      expect(unknown_value).not_to(be_sensitive)
    end

    it 'returns false by default' do
      unknown_value = described_class.new

      expect(unknown_value).not_to(be_sensitive)
    end
  end

  describe '#render' do
    it 'returns the string "..."' do
      unknown_value = described_class.new

      expect(unknown_value.render).to(eq('...'))
    end
  end

  describe '#==' do
    it 'returns true when the state and class are the same' do
      value1 = described_class.new
      value2 = described_class.new

      expect(value1).to(eq(value2))
    end

    it 'returns false when sensitive is different' do
      value1 = described_class.new(sensitive: true)
      value2 = described_class.new(sensitive: false)

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when the classes are different' do
      value1 = described_class.new(sensitive: true)
      value2 = Class.new(described_class).new(sensitive: true)

      expect(value1).not_to(eq(value2))
    end
  end

  describe '#hash' do
    it 'has the same result when the state and class are the same' do
      value1 = described_class.new
      value2 = described_class.new

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has a different result when sensitive is different' do
      value1 = described_class.new(sensitive: true)
      value2 = described_class.new(sensitive: false)

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when the classes are different' do
      value1 = described_class.new(sensitive: true)
      value2 = Class.new(described_class).new(sensitive: true)

      expect(value1.hash).not_to(eq(value2.hash))
    end
  end

  describe '#inspect' do
    it 'returns an ellipsis with unknown and non-sensitive by default' do
      unknown_value = described_class.new

      expect(unknown_value.inspect).to(eq('... (unknown, non-sensitive)'))
    end

    it 'returns an ellipsis with unknown and non-sensitive when ' \
       'not sensitive' do
      unknown_value = described_class.new(sensitive: false)

      expect(unknown_value.inspect).to(eq('... (unknown, non-sensitive)'))
    end

    it 'returns an ellipsis with unknown and sensitive when sensitive' do
      unknown_value = described_class.new(sensitive: true)

      expect(unknown_value.inspect).to(eq('... (unknown, sensitive)'))
    end
  end
end
