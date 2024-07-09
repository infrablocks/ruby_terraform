# frozen_string_literal: true

shared_examples(
  'a valid command line'
) do |command_klass, binary: nil, reason: nil, expected: nil, parameters: nil|
  let(:command) { command_klass.new(binary:) }
  let(:executor) { Lino::Executors::Mock.new }

  before do
    Lino.configure do |config|
      config.executor = executor
    end
    parameters.nil? ? command.execute : command.execute(parameters)
  end

  after do
    Lino.reset!
  end

  it reason do
    expect(executor.executions.map { |c| c.command_line.string })
      .to(eq([expected]))
  end
end
