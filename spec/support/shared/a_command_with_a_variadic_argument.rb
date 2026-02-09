# frozen_string_literal: true

shared_examples(
  'a command with a variadic argument'
) do |command_klass, subcommand, argument, singular: nil|
  # rubocop:disable RSpec/LeakyLocalVariable
  singular_name = singular || argument.to_s.chop
  # rubocop:enable RSpec/LeakyLocalVariable

  it_behaves_like(
    'a command with an argument',
    command_klass, subcommand, singular_name.to_sym
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "adds an argument for each element of the #{argument} array",
    expected: "terraform #{subcommand} argument-value1 argument-value2",
    binary: 'terraform',
    parameters: {
      argument => %w[argument-value1 argument-value2]
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "ensures that #{singular_name} and #{argument} " \
            'options work together',
    expected:
      "terraform #{subcommand} argument-value argument-value1 argument-value2",
    binary: 'terraform',
    parameters: {
      singular_name.to_sym => 'argument-value',
      argument => %w[argument-value1 argument-value2]
    }
  )
end
