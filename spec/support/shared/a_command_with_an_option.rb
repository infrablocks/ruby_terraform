shared_examples 'a command with an option' do |command, option, directory = nil, switch_override: nil|
  switch = if switch_override.nil?
             "-#{option.to_s.sub('_', '-')}"
           else
             switch_override
           end
  switch_value = 'option-value'
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like 'a valid command line', {
    reason: "adds a #{switch} option if a #{option} is provided",
    expected_command: "terraform #{command} #{switch}=#{switch_value}#{argument}",
    options: { directory: directory,
               option => switch_value }
  }

  it_behaves_like 'a valid command line', {
    reason: "does not add a #{switch} option if a #{option} is not provided",
    expected_command: "terraform #{command}#{argument}",
    options: { directory: directory }
  }
end
