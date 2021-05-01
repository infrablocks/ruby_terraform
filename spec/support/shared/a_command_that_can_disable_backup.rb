# frozen_string_literal: true

shared_examples(
  'a command that can disable backup'
) do |command_klass, subcommand, directory|
  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: 'disables backup if no_backup is true',
    expected: "terraform #{subcommand} -backup=- #{directory}".rstrip,
    options: {
      directory: directory,
      backup: 'some/state.tfstate.backup',
      no_backup: true
    }
  )
end
