# frozen_string_literal: true

require 'spec_helper'

O = RubyTerraform::Options

describe RubyTerraform::Options::Types::Standard do
  let(:builder) do
    Lino::CommandLineBuilder
      .for_command('test')
      .with_option_separator('=')
  end

  it 'adds the option with the supplied value' do
    option = described_class.new('-name', O.values.string('value'))
    result = option.apply(builder).build

    expect(result.to_s).to(match(/ -name=value($| )/))
  end

  it 'uses the provided separator override when supplied' do
    option = described_class.new(
      '-name', O.values.string('value'), separator: '~'
    )
    result = option.apply(builder).build

    expect(result.to_s).to(match(/ -name~value($| )/))
  end
end
