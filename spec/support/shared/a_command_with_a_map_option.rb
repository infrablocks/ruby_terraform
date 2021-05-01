# frozen_string_literal: true

shared_examples(
  'a command with a map option'
) do |command_klass, subcommand, option|
  name = "-#{option.to_s.gsub('_', '-')}"

  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: "adds a #{name} option for each key/value pair provided",
    expected:
      "terraform #{subcommand} #{name}='thing=blah' #{name}='other=wah'",
    options: {
      option => { thing: 'blah', other: 'wah' }
    }
  )
end
