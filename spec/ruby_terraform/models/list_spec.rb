# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::List do
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
