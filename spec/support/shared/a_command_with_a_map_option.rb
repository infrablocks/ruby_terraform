# frozen_string_literal: true

shared_examples(
  'a command with a map option'
) do |command_klass, subcommand, option|
  # rubocop:disable RSpec/LeakyLocalVariable
  option_name = "-#{option.to_s.gsub('_', '-')}"
  # rubocop:enable RSpec/LeakyLocalVariable

  it_behaves_like(
    'a valid command line',
    command_klass,
    reason: "adds a #{option_name} option for each key/value pair provided",
    expected:
      "terraform #{subcommand} " \
      "#{option_name}=thing=blah " \
      "#{option_name}=other=wah",
    binary: 'terraform',
    parameters: {
      option => { thing: 'blah', other: 'wah' }
    }
  )
end
