# frozen_string_literal: true

shared_examples(
  'a command with an option'
) do |command_klass, subcommand, option, name_override: nil|
  name = name_override.nil? ? "-#{option.to_s.gsub('_', '-')}" : name_override
  value = 'option-value'

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "adds a #{name} option if a #{option} is provided",
    expected: "terraform #{subcommand} #{name}=#{value}",
    binary: 'terraform',
    parameters: {
      option => value
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "does not add a #{name} option if a #{option} is not provided",
    expected: "terraform #{subcommand}",
    binary: 'terraform'
  )
end
