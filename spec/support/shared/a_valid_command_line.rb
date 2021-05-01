# frozen_string_literal: true

shared_examples(
  'a valid command line'
) do |command_klass, binary: nil, reason: nil, expected: nil, options: nil|
  let(:command) { command_klass.new(binary: binary) }

  before do
    allow(Open4).to(receive(:spawn))
    command.execute(options)
  end

  it reason do
    expect(Open4).to(have_received(:spawn).with(expected, any_args))
  end
end
