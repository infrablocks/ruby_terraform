# frozen_string_literal: true

shared_examples(
  'a command with a boolean option'
) do |command_klass, subcommand, option|
  name = "-#{option.to_s.gsub('_', '-')}"

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "includes #{name}=true when the #{option} option is true",
    expected: "terraform #{subcommand} #{name}=true",
    binary: 'terraform',
    parameters: {
      option => true
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "includes #{name}=false when the #{option} option is false",
    expected: "terraform #{subcommand} #{name}=false",
    binary: 'terraform',
    parameters: {
      option => false
    }
  )
end
