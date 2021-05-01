# frozen_string_literal: true

shared_examples(
  'a command with a flag'
) do |command_klass, subcommand, option, directory = nil|
  name = "-#{option.to_s.gsub('_', '-')}"
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: "includes the #{name} flag when the #{option} option is true",
    expected: "terraform #{subcommand} #{name}#{argument}",
    options: {
      directory: directory,
      option => true
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason:
      "does not include the #{name} flag when the #{option} option is false",
    expected: "terraform #{subcommand}#{argument}",
    options: {
      directory: directory,
      option => false
    }
  )
end
