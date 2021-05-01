# frozen_string_literal: true

require_relative './global_options'

shared_examples(
  'a command with global options'
) do |command_klass, subcommand|
  GlobalOptions.each_key do |opt_key|
    it_behaves_like(
      'a command with a global option',
      command_klass, subcommand, opt_key
    )
  end
end
