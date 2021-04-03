shared_examples 'an option that converts its value to a boolean' do
  context 'when the value is nil' do
    let(:value) { nil }

    it 'sets the option value to nil' do
      expect(option.instance_variable_get(:@value)).to be_nil
    end
  end

  context 'when the value is true' do
    let(:value) { true }

    it 'sets the option value to true' do
      expect(option.instance_variable_get(:@value)).to be_truthy
    end
  end

  context "when the value is 'true'" do
    let(:value) { 'true' }

    it 'sets the option value to true' do
      expect(option.instance_variable_get(:@value)).to be_truthy
    end
  end

  context 'when the value is false' do
    let(:value) { false }

    it 'sets the option value to false' do
      expect(option.instance_variable_get(:@value)).to be_falsey
    end
  end

  context 'when the value is not true/false or a string starting with T' do
    let(:value) { 'unknown' }

    it 'sets the option value to false' do
      expect(option.instance_variable_get(:@value)).to be_falsey
    end
  end
end
