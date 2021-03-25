require_relative '../../../lib/ruby_terraform/command_line/options'

shared_examples 'a command that accepts global options' do |command, directory = nil|
  RubyTerraform::CommandLine::Options.global_options.each do |option|
    it_behaves_like 'a command with an option', [command, option, directory]
  end
end
