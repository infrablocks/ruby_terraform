shared_examples 'a command with a boolean option' do |command, option, directory = nil|
  switch = "-#{option.to_s.sub('_', '-')}"
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like 'a valid command line', {
    reason: "includes #{switch}=true when the #{option} option is true",
    expected_command: "terraform #{command} #{switch}=true#{argument}",
    options: { directory: directory, option => true }
  }

  it_behaves_like 'a valid command line', {
    reason: "includes #{switch}=false when the #{option} option is false",
    expected_command: "terraform #{command} #{switch}=false#{argument}",
    options: { directory: directory, option => false }
  }
end
