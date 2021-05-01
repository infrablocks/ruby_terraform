# frozen_string_literal: true

shared_examples(
  'a command with an array option'
) do |command_klass, subcommand, option|
  singular = option.to_s.chop
  singular_option = singular.to_sym
  name = "-#{singular.sub('_', '-')}"

  it_behaves_like(
    'a command with an option',
    command_klass, subcommand, singular_option
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "adds a #{name} option for each element of the #{option} array",
    expected:
      "terraform #{subcommand} #{name}=option-value1 #{name}=option-value2",
    binary: 'terraform',
    parameters: {
      option => %w[option-value1 option-value2]
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "ensures that #{singular} and #{option} options work together",
    expected:
      "terraform #{subcommand} #{name}=option-value " \
          "#{name}=option-value1 #{name}=option-value2",
    binary: 'terraform',
    parameters: {
      singular_option => 'option-value',
      option => %w[option-value1 option-value2]
    }
  )
end
