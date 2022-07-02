# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::Map do
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
