shared_examples 'an option that derives the command switch' do
  context 'when no switch override is supplied' do
    it 'converts the supplied option key to kebab case to use as the switch' do
      expect(command_line_option.instance_variable_get(:@switch)).to eq('-snake-key')
    end
  end

  context 'when a switch override is supplied' do
    let(:options) { { switch_override: '-different-switch' } }

    it 'uses the switch override as the switch' do
      expect(command_line_option.instance_variable_get(:@switch)).to eq('-different-switch')
    end
  end
end
