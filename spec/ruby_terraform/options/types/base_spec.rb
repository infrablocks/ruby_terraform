# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Options::Types::Base do
  subject(:option) { described_class.new(switch, value) }

  let(:switch) { '-switch' }
  let(:value) { 'options value' }
  let(:builder) { instance_double(Lino::CommandLineBuilder) }

  describe '.new' do
    it 'uses a method to assign the options value to allow value setting ' \
       'to be overridden' do
      expect(option.instance_variable_get(:@value)).to eq(value)
    end
  end

  describe '#add_to_subcommand' do
    it 'raises an error to inform subclasses of the need to override ' \
       'the method' do
      expect do
        option.apply(builder)
      end.to raise_error(StandardError, 'not implemented')
    end
  end
end
