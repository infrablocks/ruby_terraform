shared_examples 'a command with an array option' do |command, option, directory|
  singular = option.to_s.chop!
  single_option = singular.to_sym
  switch = "-#{singular.sub('_', '-')}"

  it_behaves_like 'a command with an option',
                  [command, single_option, directory]

  it_behaves_like 'a valid command line', {
    reason: "adds a #{switch} option for each element of the #{option} array",
    expected_command: "terraform #{command} #{switch}=option-value1 #{switch}=option-value2 #{directory}",
    options: { directory: directory,
               option => %w[option-value1 option-value2] }
  }

  it_behaves_like 'a valid command line', {
    reason: "ensures that #{singular} and #{option} options work together",
    expected_command: "terraform #{command} #{switch}=option-value #{switch}=option-value1 #{switch}=option-value2 #{directory}",
    options: { directory: directory,
               single_option => 'option-value',
               option => %w[option-value1 option-value2] }
  }
end
