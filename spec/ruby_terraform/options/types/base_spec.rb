# frozen_string_literal: true

require 'spec_helper'

O = RubyTerraform::Options

describe RubyTerraform::Options::Types::Base do
  let(:builder) do
    Lino::CommandLineBuilder
      .for_command('test')
  end

  describe '#apply' do
    it 'raises an exception' do
      type = described_class.new('-opt', O.values.string('val'))
      expect { type.apply(builder) }
        .to(raise_error('Not implemented.'))
    end
  end
end
