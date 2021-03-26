shared_examples 'a command with a flag' do |command, option, directory = nil|
  switch = "-#{option.to_s.sub('_', '-')}"
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like 'a valid command line', {
    reason: "includes the #{switch} flag when the #{option} option is true",
    expected_command: "terraform #{command} #{switch}#{argument}",
    options: { directory: directory,
               option => true }
  }

  it_behaves_like 'a valid command line', {
    reason: "does not include the #{switch} flag when the #{option} option is false",
    expected_command: "terraform #{command}#{argument}",
    options: { directory: directory,
               option => false }
  }
end
