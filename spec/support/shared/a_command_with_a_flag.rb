# frozen_string_literal: true

shared_examples('a command with a flag') do |command, option, directory = nil|
  name = "-#{option.to_s.gsub('_', '-')}"
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like(
    'a valid command line',
    {
      reason: "includes the #{name} flag when the #{option} option is true",
      expected_command: "terraform #{command} #{name}#{argument}",
      options: {
        directory: directory,
        option => true
      }
    }
  )

  it_behaves_like(
    'a valid command line',
    {
      reason:
        "does not include the #{name} flag when the #{option} option is false",
      expected_command: "terraform #{command}#{argument}",
      options: {
        directory: directory,
        option => false
      }
    }
  )
end
