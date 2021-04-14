# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Options::Values::Complex do
  describe '#resolve' do
    it 'returns value as provided at construction' do
      expect(described_class.new({ a: 1 }).resolve)
        .to(eq({ a: 1 }))
    end
  end

  describe '#render' do
    it 'returns primitive value as string when provided primitive value at ' \
       'construction' do
      ['something', 1, true].each do |primitive|
        expect(described_class.new(primitive).render)
          .to(eq(primitive.to_s))
      end
    end

    it 'returns stringified JSON when provided array value at construction' do
      expect(described_class.new([1, 2, 3]).render)
        .to(eq('[1,2,3]'))
    end

    it 'returns stringified JSON when provided hash value at construction' do
      expect(described_class.new({ first: 1, second: 2 }).render)
        .to(eq('{"first":1,"second":2}'))
    end
  end
end
