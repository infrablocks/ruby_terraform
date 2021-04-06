# frozen_string_literal: true

shared_examples(
  'a command with an option'
) do |command, option, directory = nil, name_override: nil|
  name = name_override.nil? ? "-#{option.to_s.gsub('_', '-')}" : name_override
  value = 'option-value'
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like(
    'a valid command line',
    {
      reason: "adds a #{name} option if a #{option} is provided",
      expected_command: "terraform #{command} #{name}=#{value}#{argument}",
      options: {
        directory: directory,
        option => value
      }
    }
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: "does not add a #{name} option if a #{option} is not provided",
      expected_command: "terraform #{command}#{argument}",
      options: {
        directory: directory
      }
    }
  )
end
