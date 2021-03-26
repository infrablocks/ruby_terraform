shared_examples 'a command with a map option' do |command, option, directory = nil|
  switch = "-#{option.to_s.sub('_', '-')}"
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like 'a valid command line', {
    reason: "adds a #{switch} option for each key/value pair provided",
    expected_command: "terraform #{command} #{switch} 'thing=blah' #{switch} 'other=wah'#{argument}",
    options: { directory: directory,
               option => {
                 thing: 'blah',
                 other: 'wah'
               } }
  }
end
