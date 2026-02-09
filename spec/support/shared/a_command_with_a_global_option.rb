# frozen_string_literal: true

shared_examples(
  'a command with a global option'
) do |command_klass, subcommand, option, name_override: nil|
  # rubocop:disable RSpec/LeakyLocalVariable
  option_name = name_override || "-#{option.to_s.gsub('_', '-')}"
  # rubocop:enable RSpec/LeakyLocalVariable

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "adds a #{option_name} option if a #{option} is provided",
    expected: "terraform #{option_name}=option-value #{subcommand}",
    binary: 'terraform',
    parameters: {
      option => 'option-value'
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "does not add a #{option_name} option " \
            "if a #{option} is not provided",
    expected: "terraform #{subcommand}",
    binary: 'terraform'
  )
end
