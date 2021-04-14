# frozen_string_literal: true

require 'spec_helper'
require 'open4'

O = RubyTerraform::Options

describe RubyTerraform::Commands::Base do
  after do
    RubyTerraform.reset!
  end

  describe 'by default' do
    it 'uses the globally defined binary' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(described_class)
      instance = klass.new

      allow(Open4).to(receive(:spawn))

      instance.execute

      expect(Open4)
        .to(have_received(:spawn)
              .with(/#{binary}/, any_args))
    end

    it 'has no arguments, subcommands or options' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(described_class)
      instance = klass.new

      allow(Open4).to(receive(:spawn))

      instance.execute

      expect(Open4)
        .to(have_received(:spawn)
              .with(/^#{binary}$/, any_args))
    end
  end

  describe 'when building commands' do
    it 'includes all subcommands' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(RubyTerraform::Commands::Base) do
        def subcommands
          %w[sub1 sub2]
        end
      end
      instance = klass.new

      allow(Open4).to(receive(:spawn))

      instance.execute

      expect(Open4)
        .to(have_received(:spawn)
              .with(/^#{binary} sub1 sub2/, any_args))
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
      instance = klass.new(options: options)

      allow(Open4).to(receive(:spawn))

      instance.execute(opt1: 'val1', opt2: 'val2')

      expect(Open4)
        .to(have_received(:spawn)
              .with(/^#{binary} -opt1=val1 -opt2=val2/, any_args))
    end

    it 'includes all arguments' do
      binary = RubyTerraform.configuration.binary
      klass = Class.new(RubyTerraform::Commands::Base) do
        def arguments(parameters)
          [parameters[:arg1], parameters[:arg2]]
        end
      end
      instance = klass.new

      allow(Open4).to(receive(:spawn))

      instance.execute(arg1: 'val1', arg2: 'val2')

      expect(Open4)
        .to(have_received(:spawn)
              .with(/^#{binary} val1 val2/, any_args))
    end

    it 'uses = as the option separator' do
      klass = Class.new(RubyTerraform::Commands::Base) do
        def options
          %w[-thing]
        end
      end
      options = O::Factory.new([O.definition(name: '-thing')])
      instance = klass.new(options: options)

      allow(Open4).to(receive(:spawn))

      instance.execute(thing: 'whatever')

      expect(Open4)
        .to(have_received(:spawn)
              .with(/-thing=whatever/, any_args))
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
      instance = klass.new(options: options)

      allow(Open4).to(receive(:spawn))

      instance.execute(thing1: 'val1', thing2: 'val2')

      expect(Open4)
        .to(have_received(:spawn)
              .with(/sub -thing1(.*)-thing2/, any_args))
    end
  end

  describe 'when executing commands' do
    it 'logs an error to the globally defined logger when the command fails' do
      exitstatus = instance_double('exit status').as_null_object
      logger = instance_double('Logger')
      RubyTerraform.configure { |c| c.logger = logger }

      klass = Class.new(described_class)
      instance = klass.new

      allow(Open4)
        .to(receive(:spawn)
              .and_raise(Open4::SpawnError.new('thing', exitstatus)))
      allow(logger).to(receive(:error))
      allow(logger).to(receive(:debug))
      allow(instance).to(receive(:class).and_return('Something::Important'))

      begin
        instance.execute
      rescue RubyTerraform::Errors::ExecutionError => e
        # expected
        puts e
      end

      expect(logger)
        .to(have_received(:error)
              .with("Failed while running 'important'."))
    end
  end
end
