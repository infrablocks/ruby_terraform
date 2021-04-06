# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Options::Types::Boolean do
  let(:builder) do
    Lino::CommandLineBuilder
      .for_command('test')
      .with_option_separator('=')
  end

  it 'adds an option with value true when passed boolean true' do
    option = described_class.new('-name', true)
    result = option.apply(builder).build

    expect(result.to_s).to(match(/ -name=true($| )/))
  end

  it 'adds an option with value true when passed string true' do
    option = described_class.new('-name', 'true')
    result = option.apply(builder).build

    expect(result.to_s).to(match(/ -name=true($| )/))
  end

  it 'adds an option with value false when passed boolean false' do
    option = described_class.new('-name', false)
    result = option.apply(builder).build

    expect(result.to_s).to(match(/ -name=false($| )/))
  end

  it 'adds an option with value false when passed string false' do
    option = described_class.new('-name', 'false')
    result = option.apply(builder).build

    expect(result.to_s).to(match(/ -name=false($| )/))
  end

  it 'treats unknown string values as false' do
    option = described_class.new('-name', 'unknown')
    result = option.apply(builder).build

    expect(result.to_s).to(match(/ -name=false($| )/))
  end

  it 'does not add an option when passed nil value' do
    option = described_class.new('-name', nil)
    result = option.apply(builder).build

    expect(result.to_s).not_to(match(/-name/))
  end
end
