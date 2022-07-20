# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::Map do
  describe '#value' do
    it 'returns the underlying map with values still boxed' do
      value = { first: V.known(1), second: V.known(2) }
      map = described_class.new(value)

      expect(map.value).to(eq(value))
    end

    it 'returns the underlying map with symbol keys when provided as strings' do
      map = described_class.new(
        { 'first' => V.known(1), 'second' => V.known(2) }
      )

      expect(map.value).to(eq({ first: V.known(1), second: V.known(2) }))
    end
  end

  describe '#unbox' do
    it 'returns underlying map after unboxing scalar entries' do
      map = described_class.new(
        { first: V.known(1), second: V.known(2) }
      )

      expect(map.unbox).to(eq({ first: 1, second: 2 }))
    end

    it 'returns underlying map after unboxing list entries' do
      map = described_class.new(
        {
          first: V.list([V.known(1), V.known(2)]),
          second: V.list([V.known(3)])
        }
      )

      expect(map.unbox).to(eq({ first: [1, 2], second: [3] }))
    end

    it 'returns underlying map after unboxing map entries' do
      map = described_class.new(
        {
          first: V.map(
            {
              third: V.known(3),
              fourth: V.known(4)
            }
          ),
          second: V.map(
            {
              fifth: V.known(5)
            }
          )
        }
      )

      expect(map.unbox)
        .to(eq(
              {
                first: { third: 3, fourth: 4 },
                second: { fifth: 5 }
              }
            ))
    end

    it 'returns underlying map with symbol keys when provided as strings' do
      map = described_class.new(
        {
          'first' => V.map(
            {
              'third' => V.known(3),
              'fourth' => V.known(4)
            }
          ),
          'second' => V.map(
            {
              'fifth' => V.known(5)
            }
          )
        }
      )

      expect(map.unbox)
        .to(eq(
              {
                first: { third: 3, fourth: 4 },
                second: { fifth: 5 }
              }
            ))
    end
  end

  describe '#known?' do
    it 'returns true' do
      map = described_class.new(
        { key: V.known(1) }
      )

      expect(map).to(be_known)
    end
  end

  describe '#sensitive?' do
    it 'returns true when sensitive' do
      map = described_class.new(
        { key: V.known(1) },
        sensitive: true
      )

      expect(map).to(be_sensitive)
    end

    it 'returns false when not sensitive' do
      map = described_class.new(
        { key: V.known(1) },
        sensitive: false
      )

      expect(map).not_to(be_sensitive)
    end

    it 'returns false by default' do
      map = described_class.new({ key: V.known(1) })

      expect(map).not_to(be_sensitive)
    end
  end

  describe '#==' do
    it 'returns true when the state and class are the same' do
      value1 = described_class.new({ some_key: 'some-value' })
      value2 = described_class.new({ some_key: 'some-value' })

      expect(value1).to(eq(value2))
    end

    it 'returns true when one provided string keys and the other symbol keys' do
      value1 = described_class.new({ 'some_key' => 'some-value' })
      value2 = described_class.new({ some_key: 'some-value' })

      expect(value1).to(eq(value2))
    end

    it 'returns false when the value is different' do
      value1 = described_class.new({ some_key: 'first-value' })
      value2 = described_class.new({ some_key: 'second-value' })

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when sensitive is different' do
      value1 = described_class.new(
        { some_key: 'some-value', sensitive: true }
      )
      value2 = described_class.new(
        { some_key: 'some-value' }, sensitive: false
      )

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when the classes are different' do
      value1 = described_class.new(
        { some_key: 'some-value' }, sensitive: true
      )
      value2 = Class.new(described_class)
                    .new({ some_key: 'some-value' }, sensitive: true)

      expect(value1).not_to(eq(value2))
    end
  end

  describe '#hash' do
    it 'has the same result when the state and class are the same' do
      value1 = described_class.new({ some_key: 'some-value' })
      value2 = described_class.new({ some_key: 'some-value' })

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has a different result when the value is different' do
      value1 = described_class.new({ some_key: 'first-value' })
      value2 = described_class.new({ some_key: 'second-value' })

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when sensitive is different' do
      value1 = described_class.new(
        { some_key: 'some-value' }, sensitive: true
      )
      value2 = described_class.new(
        { some_key: 'some-value' }, sensitive: false
      )

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when the classes are different' do
      value1 = described_class.new(
        { some_key: 'some-value' }, sensitive: true
      )
      value2 = Class.new(described_class).new(
        { some_key: 'some-value' }, sensitive: true
      )

      expect(value1.hash).not_to(eq(value2.hash))
    end
  end

  describe '#inspect' do
    it 'returns the underlying value with non-sensitive by default' do
      map = described_class.new(
        { key: V.known(1) }
      )

      expect(map.inspect)
        .to(eq('{:key=>1 (known, non-sensitive)} (non-sensitive)'))
    end

    it 'returns the underlying value with non-sensitive when not sensitive' do
      map = described_class.new(
        { key: V.known(1) },
        sensitive: false
      )

      expect(map.inspect)
        .to(eq('{:key=>1 (known, non-sensitive)} (non-sensitive)'))
    end

    it 'returns the underlying value with sensitive when sensitive' do
      map = described_class.new(
        { key: V.known(1) },
        sensitive: true
      )

      expect(map.inspect)
        .to(eq('{:key=>1 (known, non-sensitive)} (sensitive)'))
    end
  end
end
