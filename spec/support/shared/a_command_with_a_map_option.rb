shared_examples 'a command with a map option' do |command, option|
  switch = "-#{option.to_s.sub('_', '-')}"

  it_behaves_like 'a valid command line', {
    reason: "adds a #{switch} option for each key/value pair provided",
    expected_command: "terraform #{command} #{switch} 'thing=blah' #{switch} 'other=wah'",
    options: { option => { thing: 'blah', other: 'wah' } }
  }
end
