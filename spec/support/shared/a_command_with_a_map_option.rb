# frozen_string_literal: true

shared_examples('a command with a map option') do |command, option|
  name = "-#{option.to_s.gsub('_', '-')}"

  it_behaves_like(
    'a valid command line',
    {
      reason: "adds a #{name} option for each key/value pair provided",
      expected_command:
        "terraform #{command} #{name}='thing=blah' #{name}='other=wah'",
      options: {
        option => { thing: 'blah', other: 'wah' }
      }
    }
  )
end
