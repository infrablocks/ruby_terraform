# frozen_string_literal: true

require 'spec_helper'

O = RubyTerraform::Options

describe RubyTerraform::Options::Types::Flag do
  let(:builder) do
    Lino::CommandLineBuilder
      .for_command('test')
  end

  it 'adds the flag with value true when passed true value' do
    option = described_class.new('-name', O.values.boolean(true))
    result = option.apply(builder).build

    expect(result.to_s).to(match(/ -name($| )/))
  end

  it 'does not add the flag when passed false value' do
    option = described_class.new('-name', O.values.boolean(false))
    result = option.apply(builder).build

    expect(result.to_s).not_to(match(/-name/))
  end

  it 'does not add the flag when passed nil value' do
    option = described_class.new('-name', O.values.boolean(nil))
    result = option.apply(builder).build

    expect(result.to_s).not_to(match(/-name/))
  end
end
