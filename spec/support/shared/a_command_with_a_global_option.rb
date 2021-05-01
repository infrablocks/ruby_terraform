# frozen_string_literal: true

shared_examples(
  'a command with a global option'
) do |command_klass, subcommand, option, directory = nil, name_override: nil|
  name = name_override.nil? ? "-#{option.to_s.gsub('_', '-')}" : name_override
  value = 'option-value'
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: "adds a #{name} option if a #{option} is provided",
    expected: "terraform #{name}=#{value} #{subcommand}#{argument}",
    options: {
      directory: directory,
      option => value
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: "does not add a #{name} option if a #{option} is not provided",
    expected: "terraform #{subcommand}#{argument}",
    options: {
      directory: directory
    }
  )
end
