# frozen_string_literal: true

shared_examples(
  'a command that can disable backup'
) do |command_klass, subcommand|
  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: 'disables backup if no_backup is true',
    expected: "terraform #{subcommand} -backup=-",
    binary: 'terraform',
    parameters: {
      backup: 'some/state.tfstate.backup',
      no_backup: true
    }
  )
end
