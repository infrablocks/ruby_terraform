# frozen_string_literal: true

require 'spec_helper'
require 'logger'

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

      expect(executor.calls.first)
        .to(satisfy { |call| call[:command_line].string =~ /#{binary}/ })
    end

    it 'has no environment variables, arguments, subcommands or options' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(described_class)
      instance = klass.new

      instance.execute

      expect(executor.calls.first)
        .to(satisfy { |call| call[:command_line].string =~ /^#{binary}$/ })
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

      expect(executor.calls.first)
        .to(satisfy do |call|
          call[:command_line].string =~ /^SOME_THING="some-value" #{binary}/
        end)
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

      expect(executor.calls.first)
        .to(satisfy do |call|
          call[:command_line].string =~ /^#{binary} sub1 sub2/
        end)
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

      expect(executor.calls.first)
        .to(satisfy do |call|
          call[:command_line].string =~ /^#{binary} -opt1=val1 -opt2=val2/
        end)
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

      expect(executor.calls.first)
        .to(satisfy do |call|
          call[:command_line].string =~ /^#{binary} val1 val2/
        end)
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

      expect(executor.calls.first)
        .to(satisfy do |call|
          call[:command_line].string =~ /-thing=whatever/
        end)
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

      expect(executor.calls.first)
        .to(satisfy do |call|
          call[:command_line].string =~ /sub -thing1(.*)-thing2/
        end)
    end
  end

  describe 'when executing commands' do
    it 'logs an error to the globally defined logger when the command fails' do
      logger = instance_double(Logger)

      RubyTerraform.configure { |c| c.logger = logger }

      klass = Class.new(described_class)
      instance = klass.new

      executor.exit_code = 2

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
end
