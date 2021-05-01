# frozen_string_literal: true

require_relative './global_options'

shared_examples 'a command with global options' do |command, directory = nil|
  GlobalOptions.each_key do |opt_key|
    it_behaves_like(
      'a command with a global option',
      [command, opt_key, directory]
    )
  end
end
