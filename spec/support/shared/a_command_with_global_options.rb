# frozen_string_literal: true

shared_examples(
  'a command with global options'
) do |command_klass, subcommand|
  [:chdir].each do |option|
    it_behaves_like(
      'a command with a global option',
      command_klass, subcommand, option
    )
  end
end
