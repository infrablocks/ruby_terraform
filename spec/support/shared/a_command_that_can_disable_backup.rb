shared_examples 'a command that can disable backup' do |command, directory = nil|
  argument = directory.nil? ? nil : " #{directory}"

  it_behaves_like 'a valid command line', {
    reason: 'disables backup if no_backup is true',
    expected_command: "terraform #{command} -backup=- #{argument}",
    options: { directory: argument,
               backup: 'some/state.tfstate.backup',
               no_backup: true }
  }
end
