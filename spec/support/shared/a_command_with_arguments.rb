# frozen_string_literal: true

shared_examples(
  'a command with arguments'
) do |command_klass, subcommand, arguments|
  it_behaves_like(
    'a valid command line',
    command_klass,
    reason:
      "calls the terraform #{subcommand} command passing the supplied " \
      'arguments',
    expected:
      "terraform #{subcommand} " \
      "#{arguments.map { |a| "#{a}-arg-val" }.join(' ')}",
    binary: 'terraform',
    parameters: arguments.inject({}) { |p, a| p.merge(a => "#{a}-arg-val") }
  )
end
