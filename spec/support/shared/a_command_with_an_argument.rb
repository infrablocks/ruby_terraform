shared_examples('a command with an argument') do |command, argument|
  it_behaves_like(
    'a valid command line',
    {
      reason: "calls the terraform #{command} command passing the supplied " \
        "#{argument} value",
      expected_command: "terraform #{command} argument-value",
      options: {
        argument => 'argument-value'
      }
    }
  )
end
