shared_examples(
  'a command with an array option'
) do |command, option, directory|
  singular = option.to_s.chop
  singular_option = singular.to_sym
  name = "-#{singular.sub('_', '-')}"

  it_behaves_like(
    'a command with an option',
    [command, singular_option, directory]
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: "adds a #{name} option for each element of the #{option} array",
      expected_command:
        "terraform #{command} #{name}=option-value1 #{name}=option-value2 " +
          directory,
      options: {
        directory: directory,
        option => %w[option-value1 option-value2]
      }
    }
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: "ensures that #{singular} and #{option} options work together",
      expected_command:
        "terraform #{command} #{name}=option-value " \
          "#{name}=option-value1 #{name}=option-value2 #{directory}",
      options: {
        directory: directory,
        singular_option => 'option-value',
        option => %w[option-value1 option-value2]
      }
    }
  )
end
