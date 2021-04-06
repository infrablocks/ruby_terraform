# frozen_string_literal: true

shared_examples(
  'a command without a binary supplied'
) do |terraform_command, klass, directory = nil|
  context 'when no binary is supplied' do
    let(:command) { klass.new }

    argument = directory.nil? ? nil : " #{directory}"

    it_behaves_like(
      'a valid command line',
      {
        reason: 'defaults to the configured binary when none provided',
        expected_command: "path/to/binary #{terraform_command}#{argument}",
        options: { directory: directory }
      }
    )
  end
end
