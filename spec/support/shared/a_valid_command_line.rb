shared_examples 'a valid command line' do |options:, reason:, expected_command:|
  before do
    allow(Open4).to receive(:spawn)
    options.nil? ? command.execute : command.execute(options)
  end

  it reason do
    expect(Open4)
      .to(have_received(:spawn)
            .with(expected_command, any_args))
  end
end
