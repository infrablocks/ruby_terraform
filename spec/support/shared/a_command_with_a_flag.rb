# frozen_string_literal: true

shared_examples(
  'a command with a flag'
) do |command_klass, subcommand, option|
  # rubocop:disable RSpec/LeakyLocalVariable
  option_name = "-#{option.to_s.gsub('_', '-')}"
  # rubocop:enable RSpec/LeakyLocalVariable

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "includes the #{option_name} flag " \
            "when the #{option} option is true",
    expected: "terraform #{subcommand} #{option_name}",
    binary: 'terraform',
    parameters: {
      option => true
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "does not include the #{option_name} flag " \
            "when the #{option} option is false",
    expected: "terraform #{subcommand}",
    binary: 'terraform',
    parameters: {
      option => false
    }
  )
end
