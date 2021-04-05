require 'spec_helper'

describe RubyTerraform::Options::Types::Flag do
  let(:builder) do
    Lino::CommandLineBuilder
      .for_command('test')
  end

  it 'adds an option with value true when passed boolean true' do
    option = described_class.new('-name', true)
    result = option.apply(builder).build

    expect(result.to_s).to(match(/ -name($| )/))
  end

  it 'adds the flag when passed string true' do
    option = described_class.new('-name', 'true')
    result = option.apply(builder).build

    expect(result.to_s).to(match(/ -name($| )/))
  end

  it 'does not add the flag when passed boolean false' do
    option = described_class.new('-name', false)
    result = option.apply(builder).build

    expect(result.to_s).not_to(match(/-name/))
  end

  it 'does not add the flag when passed string false' do
    option = described_class.new('-name', 'false')
    result = option.apply(builder).build

    expect(result.to_s).not_to(match(/-name/))
  end

  it 'does not add the flag when passed an unknown string value' do
    option = described_class.new('-name', 'unknown')
    result = option.apply(builder).build

    expect(result.to_s).not_to(match(/-name/))
  end

  it 'does not add the flag when passed nil value' do
    option = described_class.new('-name', nil)
    result = option.apply(builder).build

    expect(result.to_s).not_to(match(/-name/))
  end
end
