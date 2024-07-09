# frozen_string_literal: true

require 'spec_helper'
require 'logger'
require 'tempfile'

describe RubyTerraform::Commands::Base do
  let(:executor) { Lino::Executors::Mock.new }

  before do
    Lino.configure do |config|
      config.executor = executor
    end
  end

  after do
    RubyTerraform.reset!
    Lino.reset!
  end

  describe 'by default' do
    it 'uses the globally defined binary' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(described_class)
      instance = klass.new

      instance.execute

      expect(executor.executions.first.command_line.string)
        .to(match(/#{binary}/))
    end

    it 'has no environment variables, arguments, subcommands or options' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(described_class)
      instance = klass.new

      instance.execute

      expect(executor.executions.first.command_line.string)
        .to(match(/^#{binary}$/))
    end
  end

  describe 'when building commands' do
    it 'includes all environment variables' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(described_class)
      instance = klass.new

      instance.execute(
        {},
        {
          environment: {
            'SOME_THING' => 'some-value'
          }
        }
      )

      expect(executor.executions.first.command_line.string)
        .to(match(/^SOME_THING="some-value" #{binary}/))
    end

    it 'includes all subcommands' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(RubyTerraform::Commands::Base) do
        def subcommands
          %w[sub1 sub2]
        end
      end
      instance = klass.new

      instance.execute

      expect(executor.executions.first.command_line.string)
        .to(match(/^#{binary} sub1 sub2/))
    end

    it 'includes all options' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(RubyTerraform::Commands::Base) do
        def options
          %w[-opt1 -opt2]
        end
      end
      options = O::Factory.new(
        [
          O.definition(name: '-opt1'),
          O.definition(name: '-opt2')
        ]
      )
      instance = klass.new(options:)

      instance.execute(opt1: 'val1', opt2: 'val2')

      expect(executor.executions.first.command_line.string)
        .to(match(/^#{binary} -opt1=val1 -opt2=val2/))
    end

    it 'includes all arguments' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(RubyTerraform::Commands::Base) do
        def arguments(parameters)
          [parameters[:arg1], parameters[:arg2]]
        end
      end
      instance = klass.new

      instance.execute(arg1: 'val1', arg2: 'val2')

      expect(executor.executions.first.command_line.string)
        .to(match(/^#{binary} val1 val2/))
    end

    it 'uses = as the option separator' do
      klass = Class.new(RubyTerraform::Commands::Base) do
        def options
          %w[-thing]
        end
      end
      options = O::Factory.new([O.definition(name: '-thing')])
      instance = klass.new(options:)

      instance.execute(thing: 'whatever')

      expect(executor.executions.first.command_line.string)
        .to(match(/-thing=whatever/))
    end

    it 'places options after subcommands' do
      klass = Class.new(RubyTerraform::Commands::Base) do
        def options
          %w[-thing1 -thing2]
        end

        def subcommands
          %w[sub]
        end
      end
      options = O::Factory.new(
        [
          O.definition(name: '-thing1'),
          O.definition(name: '-thing2')
        ]
      )
      instance = klass.new(options:)

      instance.execute(thing1: 'val1', thing2: 'val2')

      expect(executor.executions.first.command_line.string)
        .to(match(/sub -thing1(.*)-thing2/))
    end
  end

  describe 'when executing commands' do
    describe 'logging' do
      it 'logs an error to the globally defined logger ' \
         'when the command fails' do
        logger = instance_double(Logger)

        RubyTerraform.configure { |c| c.logger = logger }

        klass = Class.new(described_class)
        instance = klass.new

        executor.fail_all_executions

        allow(logger).to(receive(:error))
        allow(logger).to(receive(:debug))
        allow(instance).to(receive(:class).and_return('Something::Important'))

        begin
          instance.execute
        rescue RubyTerraform::Errors::ExecutionError
          # expected
        end

        expect(logger)
          .to(have_received(:error)
                .with("Failed while running 'important'."))
      end
    end

    describe 'streams' do
      it 'uses the globally defined stdin stream when none provided' do
        stdin = StringIO.new("yes\nno\n")

        RubyTerraform.configure do |c|
          c.stdin = stdin
        end

        klass = Class.new(described_class)
        instance = klass.new

        instance.execute

        expect(executor.executions.first.opts[:stdin]).to(eq(stdin))
      end

      it 'uses the stdin stream provided at construction time ' \
         'when provided' do
        stdin1 = StringIO.new("yes\nno\n")
        stdin2 = StringIO.new("no\nyes\n")

        RubyTerraform.configure do |c|
          c.stdin = stdin1
        end

        klass = Class.new(described_class)
        instance = klass.new(stdin: stdin2)

        instance.execute

        expect(executor.executions.first.opts[:stdin]).to(eq(stdin2))
      end

      it 'uses the globally defined stdout stream when none provided' do
        stdout = Tempfile.new('test')

        RubyTerraform.configure do |c|
          c.stdout = stdout
        end

        klass = Class.new(described_class)
        instance = klass.new

        instance.execute

        expect(executor.executions.first.opts[:stdout]).to(eq(stdout))
      end

      it 'uses the stdout stream provided at construction time ' \
         'when provided' do
        stdout1 = Tempfile.new('test1')
        stdout2 = Tempfile.new('test2')

        RubyTerraform.configure do |c|
          c.stdout = stdout1
        end

        klass = Class.new(described_class)
        instance = klass.new(stdout: stdout2)

        instance.execute

        expect(executor.executions.first.opts[:stdout]).to(eq(stdout2))
      end

      it 'captures and returns stdout when requested at ' \
         'execution time' do
        klass = Class.new(described_class)
        instance = klass.new

        executor.write_to_stdout('command output')

        result = instance.execute({}, { capture: [:stdout] })

        expect(result).to(eq({ output: 'command output' }))
      end

      it 'allows subclasses to request stdout capture' do
        klass = Class.new(described_class) do
          def invocation_option_defaults(_invocation_options)
            { capture: [:stdout] }
          end
        end
        instance = klass.new

        executor.write_to_stdout('command output')

        result = instance.execute

        expect(result).to(eq({ output: 'command output' }))
      end

      it 'allows subclass stdout capture request to be overridden ' \
         'at execution time' do
        stdout = Tempfile.new

        RubyTerraform.configure do |c|
          c.stdout = stdout
        end

        klass = Class.new(described_class) do
          def invocation_option_defaults(_invocation_options)
            { capture: [:stdout] }
          end
        end
        instance = klass.new

        executor.write_to_stdout('command output')

        instance.execute({}, { capture: [] })

        stdout.rewind

        expect(stdout.read).to(eq('command output'))
      end

      it 'uses the globally defined stderr stream when none provided' do
        stderr = Tempfile.new('test')

        RubyTerraform.configure do |c|
          c.stderr = stderr
        end

        klass = Class.new(described_class)
        instance = klass.new

        instance.execute

        expect(executor.executions.first.opts[:stderr]).to(eq(stderr))
      end

      it 'uses the stderr stream provided at construction time ' \
         'when provided' do
        stderr1 = Tempfile.new('test1')
        stderr2 = Tempfile.new('test2')

        RubyTerraform.configure do |c|
          c.stderr = stderr1
        end

        klass = Class.new(described_class)
        instance = klass.new(stderr: stderr2)

        instance.execute

        expect(executor.executions.first.opts[:stderr]).to(eq(stderr2))
      end

      it 'captures and returns stderr when requested at ' \
         'execution time' do
        klass = Class.new(described_class)
        instance = klass.new

        executor.write_to_stderr('command error')

        result = instance.execute({}, { capture: [:stderr] })

        expect(result).to(eq({ error: 'command error' }))
      end

      it 'allows subclasses to request stderr capture' do
        klass = Class.new(described_class) do
          def invocation_option_defaults(_invocation_options)
            { capture: [:stderr] }
          end
        end
        instance = klass.new

        executor.write_to_stderr('command error')

        result = instance.execute

        expect(result).to(eq({ error: 'command error' }))
      end

      it 'allows subclass stderr capture request to be overridden ' \
         'at execution time' do
        stderr = Tempfile.new

        RubyTerraform.configure do |c|
          c.stderr = stderr
        end

        klass = Class.new(described_class) do
          def invocation_option_defaults(_invocation_options)
            { capture: [:stderr] }
          end
        end
        instance = klass.new

        executor.write_to_stderr('command error')

        instance.execute({}, { capture: [] })

        stderr.rewind

        expect(stderr.read).to(eq('command error'))
      end
    end

    describe 'processing' do
      it 'allows subclasses to define result processor applied to ' \
         'captured result' do
        klass = Class.new(described_class) do
          def process_result(result, _parameters, _invocation_options)
            result[:output]
          end
        end
        instance = klass.new

        executor.write_to_stdout('command output')

        result = instance.execute({}, { capture: [:stdout] })

        expect(result).to(eq('command output'))
      end

      it 'skips result processing when raw result requested' do
        klass = Class.new(described_class) do
          def process_result(result, _parameters, _invocation_options)
            result[:output]
          end
        end
        instance = klass.new

        executor.write_to_stdout('command output')

        result = instance.execute({}, { capture: [:stdout], result: :raw })

        expect(result).to(eq({ output: 'command output' }))
      end
    end
  end
end
