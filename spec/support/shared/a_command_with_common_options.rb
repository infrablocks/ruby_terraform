# frozen_string_literal: true

require_relative './common_options'

shared_examples 'a command with common options' do |command, directory = nil|
  CommonOptions.each_key do |opt_key|
    it_behaves_like 'a command with an option', [command, opt_key, directory]
  end
end
