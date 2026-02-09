# frozen_string_literal: true

shared_examples(
  'a command with an array option'
) do |command_klass, subcommand, option|
  # rubocop:disable RSpec/LeakyLocalVariable
  singular = option.to_s.chop
  singular_option = singular.to_sym
  option_name = "-#{singular.sub('_', '-')}"
  # rubocop:enable RSpec/LeakyLocalVariable

  it_behaves_like(
    'a command with an option',
    command_klass, subcommand, singular_option
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "adds a #{option_name} option " \
            "for each element of the #{option} array",
    expected: "terraform #{subcommand} " \
              "#{option_name}=option-value1 " \
              "#{option_name}=option-value2",
    binary: 'terraform',
    parameters: {
      option => %w[option-value1 option-value2]
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "ensures that #{singular} and #{option} " \
            'options work together',
    expected: "terraform #{subcommand} " \
              "#{option_name}=option-value " \
              "#{option_name}=option-value1 " \
              "#{option_name}=option-value2",
    binary: 'terraform',
    parameters: {
      singular_option => 'option-value',
      option => %w[option-value1 option-value2]
    }
  )
end
