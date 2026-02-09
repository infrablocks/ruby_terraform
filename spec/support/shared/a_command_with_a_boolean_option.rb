# frozen_string_literal: true

shared_examples(
  'a command with a boolean option'
) do |command_klass, subcommand, option|
  # rubocop:disable RSpec/LeakyLocalVariable
  option_name = "-#{option.to_s.gsub('_', '-')}"
  # rubocop:enable RSpec/LeakyLocalVariable

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "includes #{option_name}=true when the #{option} option is true",
    expected: "terraform #{subcommand} #{option_name}=true",
    binary: 'terraform',
    parameters: {
      option => true
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "includes #{option_name}=false when the #{option} option is false",
    expected: "terraform #{subcommand} #{option_name}=false",
    binary: 'terraform',
    parameters: {
      option => false
    }
  )
end
