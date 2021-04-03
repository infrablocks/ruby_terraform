# frozen_string_literal: true

shared_examples(
  'a command with a boolean option'
) do |command, option, directory = nil|
  name = "-#{option.to_s.gsub('_', '-')}"
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like(
    'a valid command line',
    {
      reason: "includes #{name}=true when the #{option} option is true",
      expected_command: "terraform #{command} #{name}=true#{argument}",
      options: {
        directory: directory,
        option => true
      }
    }
  )

  it_behaves_like(
    'a valid command line',
    {
      reason: "includes #{name}=false when the #{option} option is false",
      expected_command: "terraform #{command} #{name}=false#{argument}",
      options: {
        directory: directory,
        option => false
      }
    }
  )
end
