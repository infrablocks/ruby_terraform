# frozen_string_literal: true

shared_examples(
  'a command with a boolean option'
) do |command_klass, subcommand, option, directory = nil|
  name = "-#{option.to_s.gsub('_', '-')}"
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: "includes #{name}=true when the #{option} option is true",
    expected: "terraform #{subcommand} #{name}=true#{argument}",
    options: {
      directory: directory,
      option => true
    }
  )

  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason: "includes #{name}=false when the #{option} option is false",
    expected: "terraform #{subcommand} #{name}=false#{argument}",
    options: {
      directory: directory,
      option => false
    }
  )
end
