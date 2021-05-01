# frozen_string_literal: true

shared_examples(
  'a command with an argument'
) do |command_klass, subcommand, argument|
  it_behaves_like(
    'a valid command line',
    command_klass,
    binary: 'terraform',
    reason:
      "calls the terraform #{subcommand} command passing the supplied " \
        "#{argument} value",
    expected: "terraform #{subcommand} argument-value",
    options: {
      argument => 'argument-value'
    }
  )
end
