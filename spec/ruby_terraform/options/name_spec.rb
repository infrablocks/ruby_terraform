# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Options::Name do
  describe '#name' do
    context 'when the name string starts with a -' do
      it 'returns the supplied name string' do
        expect(described_class.new('-name-string').name)
          .to(eq('-name-string'))
      end
    end

    context 'when the name string does not start with a -' do
      it 'returns the name string prefixed with a -' do
        expect(described_class.new('name-string').name)
          .to(eq('-name-string'))
      end
    end

    context 'when the name string starts with multiple -' do
      it 'returns the name string prefixed with a -' do
        expect(described_class.new('--name-string').name)
          .to(eq('-name-string'))
      end
    end
  end

  describe '#to_s' do
    context 'when the name string starts with a -' do
      it 'returns the supplied name string' do
        expect(described_class.new('-name-string').to_s)
          .to(eq('-name-string'))
      end
    end

    context 'when the name string does not start with a -' do
      it 'returns the name string prefixed with a -' do
        expect(described_class.new('name-string').to_s)
          .to(eq('-name-string'))
      end
    end

    context 'when the name string starts with multiple -' do
      it 'returns the name string prefixed with a -' do
        expect(described_class.new('--name-string').to_s)
          .to(eq('-name-string'))
      end
    end
  end

  describe '#as_singular_key' do
    it 'returns the name string converted to a hash key' do
      expect(described_class.new('-name-string').as_singular_key)
        .to(eq(:name_string))
    end
  end

  describe '#as_plural_key' do
    it 'returns the name string suffixed with an s converted to a hash key' do
      expect(described_class.new('-name-string').as_plural_key)
        .to(eq(:name_strings))
    end
  end

  describe '#==' do
    it 'returns true when compared to another instance with the same ' \
       'name string' do
      name1 = described_class.new('-name-string')
      name2 = described_class.new('-name-string')

      expect(name1 == name2).to(be(true))
    end

    it 'returns true when compared to another instance with the same ' \
       'name string without a prefix' do
      name1 = described_class.new('-name-string')
      name2 = described_class.new('name-string')

      expect(name1 == name2).to(be(true))
    end

    it 'returns true when without a prefix and compared to another instance ' \
       'with the same name string with a prefix' do
      name1 = described_class.new('name-string')
      name2 = described_class.new('-name-string')

      expect(name1 == name2).to(be(true))
    end

    it 'returns false when compared to another instance with a different ' \
       'name string' do
      name1 = described_class.new('-name-string-1')
      name2 = described_class.new('-name-string-2')

      expect(name1 == name2).to(be(false))
    end

    it 'returns false when compared to an instance of a different type' do
      name1 = described_class.new('-name-string')
      name2 = '-name-string'

      expect(name1 == name2).to(be(false))
    end
  end

  describe '#eql?' do
    it 'returns true when compared to another instance with the same ' \
       'name string' do
      name1 = described_class.new('-name-string')
      name2 = described_class.new('-name-string')

      expect(name1.eql?(name2)).to(be(true))
    end

    it 'returns false when compared to another instance with a different ' \
       'name string' do
      name1 = described_class.new('-name-string-1')
      name2 = described_class.new('-name-string-2')

      expect(name1.eql?(name2)).to(be(false))
    end

    it 'returns false when compared to an instance of a different type' do
      name1 = described_class.new('-name-string')
      name2 = '-name-string'

      expect(name1.eql?(name2)).to(be(false))
    end
  end

  describe '#hash' do
    it 'returns the same hash when the name string is the same' do
      name1 = described_class.new('-name-string')
      name2 = described_class.new('-name-string')

      expect(name1.hash).to(be(name2.hash))
    end

    it 'returns a different hash when the name string is different' do
      name1 = described_class.new('-name-string-1')
      name2 = described_class.new('-name-string-2')

      expect(name1.hash).not_to(be(name2.hash))
    end
  end
end
