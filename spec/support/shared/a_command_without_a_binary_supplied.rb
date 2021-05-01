# frozen_string_literal: true

shared_examples(
  'a command without a binary supplied'
) do |command_klass, subcommand|
  context 'when no binary is supplied' do
    it_behaves_like(
      'a valid command line',
      command_klass,
      reason: 'defaults to the configured binary when none provided',
      expected: "path/to/binary #{subcommand}"
    )
  end
end
