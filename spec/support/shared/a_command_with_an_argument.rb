# frozen_string_literal: true

shared_examples(
  'a command with an argument'
) do |command_klass, subcommand, argument|
  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "calls the terraform #{subcommand} command passing the supplied " \
      "#{argument} value",
    expected: "terraform #{subcommand} argument-value",
    binary: 'terraform',
    parameters: {
      argument => 'argument-value'
    }
  )
end
