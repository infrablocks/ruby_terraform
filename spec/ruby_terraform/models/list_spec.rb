# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::List do
  describe '#value' do
    it 'returns the underlying array with values still boxed' do
      value = [V.known(1), V.known(2), V.known(3)]
      list = described_class.new(
        value,
        sensitive: true
      )

      expect(list.value).to(eq(value))
    end
  end

  describe '#unbox' do
    it 'returns underlying array after unboxing scalar items' do
      list = described_class.new(
        [V.known(1), V.known(2), V.known(3)],
        sensitive: true
      )

      expect(list.unbox).to(eq([1, 2, 3]))
    end

    it 'returns underlying array after unboxing list items' do
      list = described_class.new(
        [V.list([V.known(1), V.known(2)]), V.list([V.known(3)])],
        sensitive: true
      )

      expect(list.unbox).to(eq([[1, 2], [3]]))
    end

    it 'returns underlying array after unboxing map items' do
      list = described_class.new(
        [
          V.map(
            {
              first: V.known(1),
              second: V.known(2)
            }
          ),
          V.map(
            {
              third: V.known(3)
            }
          )
        ],
        sensitive: true
      )

      expect(list.unbox).to(eq([{ first: 1, second: 2 }, { third: 3 }]))
    end
  end

  describe '#known?' do
    it 'returns true' do
      list = described_class.new(
        [V.known(1), V.known(2), V.known(3)],
        sensitive: true
      )

      expect(list).to(be_known)
    end
  end

  describe '#sensitive?' do
    it 'returns true when sensitive' do
      list = described_class.new(
        [V.known(1), V.known(2), V.known(3)],
        sensitive: true
      )

      expect(list).to(be_sensitive)
    end

    it 'returns false when not sensitive' do
      list = described_class.new(
        [V.known(1), V.known(2), V.known(3)],
        sensitive: false
      )

      expect(list).not_to(be_sensitive)
    end

    it 'returns false by default' do
      list = described_class.new(
        [V.known(1), V.known(2), V.known(3)]
      )

      expect(list).not_to(be_sensitive)
    end
  end

  describe '#inspect' do
    it 'returns the underlying value with non-sensitive by default' do
      list = described_class.new(
        [V.known(1)]
      )

      expect(list.inspect)
        .to(eq('[1 (known, non-sensitive)] (non-sensitive)'))
    end

    it 'returns the underlying value with non-sensitive when not sensitive' do
      list = described_class.new(
        [V.known(1)],
        sensitive: false
      )

      expect(list.inspect)
        .to(eq('[1 (known, non-sensitive)] (non-sensitive)'))
    end

    it 'returns the underlying value with sensitive when sensitive' do
      list = described_class.new(
        [V.known(1)],
        sensitive: true
      )

      expect(list.inspect)
        .to(eq('[1 (known, non-sensitive)] (sensitive)'))
    end
  end
end
