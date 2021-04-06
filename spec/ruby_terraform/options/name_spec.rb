# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Options::Name do
  subject(:name) { described_class.new(name_string) }

  let(:name_string) { '-name-string' }

  describe '#to_s' do
    context 'when the name string starts with a -' do
      it 'returns the supplied name string' do
        expect(name.to_s).to eq('-name-string')
      end
    end

    context 'when the name string does not start with a -' do
      let(:name_string) { 'name-string' }

      it 'returns the name string prefixed with a -' do
        expect(name.to_s).to eq('-name-string')
      end
    end
  end

  describe '#as_key' do
    it 'returns the name string converted to a hash key' do
      expect(name.as_key).to eq(:name_string)
    end
  end

  describe '#as_plural_key' do
    it 'returns the name string suffixed with an s converted to a hash key' do
      expect(name.as_plural_key).to eq(:name_strings)
    end
  end

  describe '#==' do
    it 'returns true when compared to a string matching the name_string' do
      expect(name == '-name-string').to be_truthy
    end

    it 'returns true when compared to a string not matching the name_string' do
      expect(name == '-different-name').to be_falsey
    end
  end
end
