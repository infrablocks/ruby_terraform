# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Options::Factory do
  context 'when boolean' do
    it 'builds a boolean option' do
      definitions = [
        O.definition(
          name: '-option', option_type: :standard, value_type: :boolean
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: true }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq([O.types.standard(
          O.name('-option'), O.values.boolean(true)
        )]))
    end

    it 'builds a flag option' do
      definitions = [
        O.definition(
          name: '-option', option_type: :flag, value_type: :boolean
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: false }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq([O.types.flag(
          O.name('-option'), O.values.boolean(false)
        )]))
    end
  end

  context 'when standard' do
    it 'builds a standard option with a string value' do
      definitions = [
        O.definition(
          name: '-option', option_type: :standard, value_type: :string
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: 'value' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq([O.types.standard(
          O.name('-option'), O.values.string('value')
        )]))
    end

    it 'builds a standard option with an array complex value' do
      definitions = [
        O.definition(
          name: '-option', option_type: :standard, value_type: :complex
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: [1, 2, 3] }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq([O.types.standard(
          O.name('-option'), O.values.complex([1, 2, 3])
        )]))
    end

    it 'builds a standard option with a hash complex value' do
      definitions = [
        O.definition(
          name: '-option', option_type: :standard, value_type: :complex
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: { a: 1, b: 2 } }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq([O.types.standard(
          O.name('-option'), O.values.complex({ a: 1, b: 2 })
        )]))
    end
  end

  context 'when repeatable' do
    it 'builds standard options with string type values for an ' \
       'array parameter' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { options: %w[first second] }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(
                  O.name('-option'),
                  O.values.string('first')
                ),
                O.types.standard(
                  O.name('-option'),
                  O.values.string('second')
                )
              ]
            ))
    end

    it 'builds standard options with string type values for a ' \
       'hash parameter' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { options: { a: 'first', b: 'second' } }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(
                  O.name('-option'),
                  O.values.key_value(:a, O.values.string('first'))
                ),
                O.types.standard(
                  O.name('-option'),
                  O.values.key_value(:b, O.values.string('second'))
                )
              ]
            ))
    end

    it 'builds a standard option with a string type value for a ' \
       'string parameter' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { options: 'first' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(
                  O.name('-option'),
                  O.values.string('first')
                )
              ]
            ))
    end

    it 'builds standard options with complex type values for an ' \
       'array parameter' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :complex,
          repeatable: true
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { options: [{ a: 1 }, 'second'] }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(
                  O.name('-option'),
                  O.values.complex({ a: 1 })
                ),
                O.types.standard(
                  O.name('-option'),
                  O.values.complex('second')
                )
              ]
            ))
    end

    it 'builds standard options with complex type values for a ' \
       'hash parameter' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :complex,
          repeatable: true
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { options: { a: { first: 1 }, b: 'second' } }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(
                  O.name('-option'),
                  O.values.key_value(:a, O.values.complex({ first: 1 }))
                ),
                O.types.standard(
                  O.name('-option'),
                  O.values.key_value(:b, O.values.complex('second'))
                )
              ]
            ))
    end

    it 'builds a standard option with a complex type value for a ' \
       'string parameter' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :complex,
          repeatable: true
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { options: 'first' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(
                  O.name('-option'),
                  O.values.complex('first')
                )
              ]
            ))
    end

    it 'allows a single value to be provided under the singular key' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: 'first' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(
                  O.name('-option'),
                  O.values.string('first')
                )
              ]
            ))
    end

    it 'allows both singular and plural keys to work together' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = {
        option: 'first',
        options: %w[second third]
      }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(
                  O.name('-option'),
                  O.values.string('first')
                ),
                O.types.standard(
                  O.name('-option'),
                  O.values.string('second')
                ),
                O.types.standard(
                  O.name('-option'),
                  O.values.string('third')
                )
              ]
            ))
    end
  end

  context 'when extra keys configured' do
    it 'looks for parameter at extra singular keys' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          extra_keys: {
            singular: %i[opt1 opt2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { opt1: 'val1' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [O.types.standard(O.name('-option'), O.values.string('val1'))]
            ))
    end

    it 'continues to support default singular key when extras provided ' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          extra_keys: {
            singular: %i[opt1 opt2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: 'value' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [O.types.standard(O.name('-option'), O.values.string('value'))]
            ))
    end

    it 'collects across default and extra singular keys when repeatable' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true,
          extra_keys: {
            singular: %i[opt1 opt2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: 'val1', opt2: 'val2' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(O.name('-option'), O.values.string('val1')),
                O.types.standard(O.name('-option'), O.values.string('val2'))
              ]
            ))
    end

    it 'collects across many extra singular keys when repeatable' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true,
          extra_keys: {
            singular: %i[opt1 opt2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { opt1: 'val1', opt2: 'val2' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(O.name('-option'), O.values.string('val1')),
                O.types.standard(O.name('-option'), O.values.string('val2'))
              ]
            ))
    end

    it 'raises when parameters provided for both default and extra ' \
       'singular key when not repeatable' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: false,
          extra_keys: {
            singular: %i[opt1 opt2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: 'val1', opt2: 'val2' }

      expect { factory.resolve(names, parameters) }
        .to(raise_error(
              "Multiple values provided for '-option' " \
              '(with keys [:option, :opt1, :opt2]) and option not repeatable.'
            ))
    end

    it 'raises when parameters provided for many extra singular keys when ' \
       'not repeatable' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: false,
          extra_keys: {
            singular: %i[opt1 opt2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { opt1: 'val1', opt2: 'val2' }

      expect { factory.resolve(names, parameters) }
        .to(raise_error(
              "Multiple values provided for '-option' " \
              '(with keys [:option, :opt1, :opt2]) and option not repeatable.'
            ))
    end

    it 'looks for parameters at extra plural keys' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true,
          extra_keys: {
            plural: %i[opts1 opts2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { opts1: %w[val1 val2] }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(O.name('-option'), O.values.string('val1')),
                O.types.standard(O.name('-option'), O.values.string('val2'))
              ]
            ))
    end

    it 'continues to support default plural key when extras provided ' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true,
          extra_keys: {
            plural: %i[opts1 opts2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { options: %w[val1 val2] }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(O.name('-option'), O.values.string('val1')),
                O.types.standard(O.name('-option'), O.values.string('val2'))
              ]
            ))
    end

    it 'collects across default and extra plural keys when repeatable' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true,
          extra_keys: {
            plural: %i[opts1 opts2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { options: %w[val1], opts2: %w[val2 val3] }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(O.name('-option'), O.values.string('val1')),
                O.types.standard(O.name('-option'), O.values.string('val2')),
                O.types.standard(O.name('-option'), O.values.string('val3'))
              ]
            ))
    end

    it 'collects across many extra plural keys when repeatable' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true,
          extra_keys: {
            plural: %i[opts1 opts2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { opts1: %w[val1], opts2: %w[val2 val3] }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(O.name('-option'), O.values.string('val1')),
                O.types.standard(O.name('-option'), O.values.string('val2')),
                O.types.standard(O.name('-option'), O.values.string('val3'))
              ]
            ))
    end

    it 'ignores extra plural keys when not repeatable' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: false,
          extra_keys: {
            plural: %i[opts1 opts2]
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: 'value', opts1: %w[val2 val3] }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(O.name('-option'), O.values.string('value'))
              ]
            ))
    end
  end

  context 'when override keys configured' do
    it 'uses the specified singular override key' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          override_keys: {
            singular: :opt
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { opt: 'val' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [O.types.standard(O.name('-option'), O.values.string('val'))]
            ))
    end

    it 'ignores the default singular key when overridden' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          override_keys: {
            singular: :opt
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: 'val' }

      options = factory.resolve(names, parameters)

      expect(options).to(eq([]))
    end

    it 'uses the specified plural override key' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true,
          override_keys: {
            plural: :opts
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { opts: %w[val1 val2] }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(O.name('-option'), O.values.string('val1')),
                O.types.standard(O.name('-option'), O.values.string('val2'))
              ]
            ))
    end

    it 'ignores the default plural key when overridden' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          override_keys: {
            plural: :opts
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { options: %w[val1 val2] }

      options = factory.resolve(names, parameters)

      expect(options).to(eq([]))
    end

    it 'disables the default singular key when singular key override ' \
       'is false' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true,
          override_keys: {
            singular: false
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = {
        option: 'val0',
        options: %w[val1 val2]
      }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(O.name('-option'), O.values.string('val1')),
                O.types.standard(O.name('-option'), O.values.string('val2'))
              ]
            ))
    end

    it 'disables the default plural key when plural key override is false' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          repeatable: true,
          override_keys: {
            plural: false
          }
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = {
        option: 'val0',
        options: %w[val1 val2]
      }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq(
              [
                O.types.standard(O.name('-option'), O.values.string('val0'))
              ]
            ))
    end
  end

  context 'when separator provided' do
    it 'builds a standard option with the provided separator' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          separator: ' '
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: 'value' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq([O.types.standard(
          O.name('-option'), O.values.string('value'), separator: ' '
        )]))
    end
  end

  context 'when placement provided' do
    it 'builds a standard option with the provided placement' do
      definitions = [
        O.definition(
          name: '-option',
          option_type: :standard,
          value_type: :string,
          placement: :after_subcommands
        )
      ]
      factory = O::Factory.new(definitions)
      names = ['-option']
      parameters = { option: 'value' }

      options = factory.resolve(names, parameters)

      expect(options)
        .to(eq([O.types.standard(
          O.name('-option'),
          O.values.string('value'),
          placement: :after_subcommands
        )]))
    end
  end
end

# defaulting of definition parameters
# multiple names in one resolve
