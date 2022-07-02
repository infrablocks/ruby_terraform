# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::Objects do
  describe '.paths' do
    it 'returns the paths for an object of scalars' do
      object = {
        first: 1,
        second: '2',
        third: false
      }
      paths = described_class.paths(object)

      expect(paths).to(eq([[:first], [:second], [:third]]))
    end

    it 'returns the paths for an object of lists' do
      object = {
        first: [1, 2, 3],
        second: %w[value1 value2]
      }
      paths = described_class.paths(object)

      expect(paths)
        .to(eq([
                 [:first, 0],
                 [:first, 1],
                 [:first, 2],
                 [:second, 0],
                 [:second, 1]
               ]))
    end

    it 'returns the paths for an object of objects' do
      object = {
        first: {
          a: 1,
          b: 2
        },
        second: {
          c: 3,
          d: 4
        }
      }
      paths = described_class.paths(object)

      expect(paths)
        .to(eq([
                 %i[first a],
                 %i[first b],
                 %i[second c],
                 %i[second d]
               ]))
    end

    it 'returns the paths for a nested complex object' do
      object = {
        a: {
          b: [1, 2, 3],
          c: [
            { d: 'value1', e: 'value2' },
            { d: 'value3', e: 'value4' }
          ],
          f: true
        }
      }
      paths = described_class.paths(object)

      expect(paths)
        .to(eq([
                 [:a, :b, 0],
                 [:a, :b, 1],
                 [:a, :b, 2],
                 [:a, :c, 0, :d],
                 [:a, :c, 0, :e],
                 [:a, :c, 1, :d],
                 [:a, :c, 1, :e],
                 %i[a f]
               ]))
    end
  end

  describe '.box' do
    it 'boxes standard scalar attribute values' do
      object = {
        attribute1: 'value1',
        attribute2: false,
        attribute3: 300
      }
      sensitive = {}

      boxed = described_class.box(object, sensitive: sensitive)

      expect(boxed)
        .to(eq(V.map(
                 {
                   attribute1: V.known('value1'),
                   attribute2: V.known(false),
                   attribute3: V.known(300)
                 }
               )))
    end

    it 'boxes standard list attribute values' do
      object = {
        attribute1: %w[value1 value2 value3],
        attribute2: [true, false, true]
      }
      sensitive = {}

      boxed = described_class.box(object, sensitive: sensitive)

      expect(boxed)
        .to(eq(V.map(
                 {
                   attribute1: V.list(
                     [
                       V.known('value1'),
                       V.known('value2'),
                       V.known('value3')
                     ]
                   ),
                   attribute2: V.list(
                     [
                       V.known(true),
                       V.known(false),
                       V.known(true)
                     ]
                   )
                 }
               )))
    end

    it 'boxes standard map attribute values' do
      object = {
        attribute1: { key1: 'value1', key2: false, key3: 450 },
        attribute2: { key4: 'value2' }
      }
      sensitive = {}

      boxed = described_class.box(object, sensitive: sensitive)

      expect(boxed)
        .to(eq(V.map(
                 {
                   attribute1: V.map(
                     {
                       key1: V.known('value1'),
                       key2: V.known(false),
                       key3: V.known(450)
                     }
                   ),
                   attribute2: V.map(
                     {
                       key4: V.known('value2')
                     }
                   )
                 }
               )))
    end

    it 'boxes standard complex nested attribute values' do
      object = {
        attribute1: {
          key1: %w[value1 value2 value3],
          key2: { key4: true },
          key3: [{ key5: ['value4'] }, { key5: ['value5'] }]
        }
      }
      sensitive = {}

      boxed = described_class.box(object, sensitive: sensitive)

      expected_key1 = V.list(
        [
          V.known('value1'),
          V.known('value2'),
          V.known('value3')
        ]
      )
      expected_key2 = V.map({ key4: V.known(true) })
      expected_key3 = V.list(
        [
          V.map({ key5: V.list([V.known('value4')]) }),
          V.map({ key5: V.list([V.known('value5')]) })
        ]
      )
      expected = V.map({
                         attribute1: V.map(
                           {
                             key1: expected_key1,
                             key2: expected_key2,
                             key3: expected_key3
                           }
                         )
                       })

      expect(boxed).to(eq(expected))
    end

    it 'boxes sensitive scalar attribute values' do
      object = {
        attribute1: 'value1',
        attribute2: false,
        attribute3: 500
      }
      sensitive = {
        attribute1: true,
        attribute2: true,
        attribute3: true
      }

      boxed = described_class.box(object, sensitive: sensitive)

      expect(boxed)
        .to(eq(V.map(
                 {
                   attribute1: V.known('value1', sensitive: true),
                   attribute2: V.known(false, sensitive: true),
                   attribute3: V.known(500, sensitive: true)
                 }
               )))
    end

    it 'boxes sensitive list attribute values' do
      object = {
        attribute1: %w[value1 value2 value3],
        attribute2: [true, false, true]
      }
      sensitive = {
        attribute1: [true, false, true],
        attribute2: [false, false, true]
      }

      boxed = described_class.box(object, sensitive: sensitive)

      expect(boxed)
        .to(eq(V.map({
                       attribute1: V.list(
                         [
                           V.known('value1', sensitive: true),
                           V.known('value2'),
                           V.known('value3', sensitive: true)
                         ]
                       ),
                       attribute2: V.list(
                         [
                           V.known(true),
                           V.known(false),
                           V.known(true, sensitive: true)
                         ]
                       )
                     })))
    end

    it 'boxes sensitive map attribute values' do
      object = {
        attribute1: { key1: 'value1', key2: false, key3: 450 },
        attribute2: { key4: 'value2' }
      }
      sensitive = {
        attribute1: { key1: true, key2: false, key3: false },
        attribute2: { key4: true }
      }

      boxed = described_class.box(object, sensitive: sensitive)

      expect(boxed)
        .to(eq(V.map(
                 {
                   attribute1: V.map(
                     {
                       key1: V.known('value1', sensitive: true),
                       key2: V.known(false),
                       key3: V.known(450)
                     }
                   ),
                   attribute2: V.map(
                     {
                       key4: V.known('value2', sensitive: true)
                     }
                   )
                 }
               )))
    end

    it 'boxes sensitive complex nested attribute values' do
      object = {
        attribute1: {
          key1: %w[value1 value2 value3],
          key2: { key4: true },
          key3: [{ key5: ['value4'] }, { key5: ['value5'] }]
        }
      }
      sensitive = {
        attribute1: {
          key1: [false, true, false],
          key3: [{ key5: [true] }, { key5: [false] }]
        }
      }

      boxed = described_class.box(object, sensitive: sensitive)

      expected_key1 = V.list(
        [
          V.known('value1'),
          V.known('value2', sensitive: true),
          V.known('value3')
        ]
      )
      expected_key2 = V.map({ key4: V.known(true) })
      expected_key3 = V.list(
        [
          V.map({ key5: V.list([V.known('value4', sensitive: true)]) }),
          V.map({ key5: V.list([V.known('value5')]) })
        ]
      )
      expected = V.map(
        {
          attribute1: V.map(
            {
              key1: expected_key1,
              key2: expected_key2,
              key3: expected_key3
            }
          )
        }
      )

      expect(boxed).to(eq(expected))
    end

    it 'boxes sensitive list attribute' do
      object = {
        attribute1: %w[value1 value2 value3],
        attribute2: [true, false, true]
      }
      sensitive = {
        attribute1: true,
        attribute2: true
      }

      boxed = described_class.box(object, sensitive: sensitive)

      expect(boxed)
        .to(eq(V.map(
                 {
                   attribute1: V.list(
                     [
                       V.known('value1'),
                       V.known('value2'),
                       V.known('value3')
                     ],
                     sensitive: true
                   ),
                   attribute2: V.list(
                     [
                       V.known(true),
                       V.known(false),
                       V.known(true)
                     ],
                     sensitive: true
                   )
                 }
               )))
    end

    it 'boxes sensitive map attribute' do
      object = {
        attribute1: { key1: 'value1', key2: false, key3: 450 },
        attribute2: { key4: 'value2' }
      }
      sensitive = {
        attribute1: true,
        attribute2: true
      }

      boxed = described_class.box(object, sensitive: sensitive)

      expect(boxed)
        .to(eq(V.map(
                 {
                   attribute1: V.map(
                     {
                       key1: V.known('value1'),
                       key2: V.known(false),
                       key3: V.known(450)
                     },
                     sensitive: true
                   ),
                   attribute2: V.map(
                     {
                       key4: V.known('value2')
                     },
                     sensitive: true
                   )
                 }
               )))
    end

    it 'boxes sensitive complex nested attributes' do
      object = {
        attribute1: {
          key1: %w[value1 value2 value3],
          key2: { key4: true },
          key3: [{ key5: ['value4'] }, { key5: ['value5'] }]
        }
      }
      sensitive = {
        attribute1: {
          key2: true,
          key3: [true, false]
        }
      }

      boxed = described_class.box(object, sensitive: sensitive)

      expected_key1 = V.list(
        [
          V.known('value1'),
          V.known('value2'),
          V.known('value3')
        ]
      )
      expected_key2 = V.map({ key4: V.known(true) }, sensitive: true)
      expected_key3 = V.list(
        [
          V.map({ key5: V.list([V.known('value4')]) }, sensitive: true),
          V.map({ key5: V.list([V.known('value5')]) }, sensitive: false)
        ]
      )
      expected = V.map(
        {
          attribute1: V.map(
            {
              key1: expected_key1,
              key2: expected_key2,
              key3: expected_key3
            }
          )
        }
      )

      expect(boxed).to(eq(expected))
    end

    it 'boxes standard unknown scalar attribute values' do
      object = {}
      sensitive = {}
      unknown = {
        attribute1: true,
        attribute2: true
      }

      boxed = described_class.box(
        object, sensitive: sensitive, unknown: unknown
      )

      expect(boxed)
        .to(eq(V.map(
                 {
                   attribute1: V.unknown,
                   attribute2: V.unknown
                 }
               )))
    end

    it 'boxes sensitive unknown scalar attribute values' do
      object = {}
      sensitive = {
        attribute1: true,
        attribute2: true
      }
      unknown = {
        attribute1: true,
        attribute2: true
      }

      boxed = described_class.box(
        object, sensitive: sensitive, unknown: unknown
      )

      expect(boxed)
        .to(eq(V.map(
                 {
                   attribute1: V.unknown(sensitive: true),
                   attribute2: V.unknown(sensitive: true)
                 }
               )))
    end

    # TODO: need to work out what happens for unknown list, map or complex
    #       attribute values
    #
    # Sometimes, plans include unknown attributes with empty lists, maps or
    # lists of maps as values. This isn't described in the docs and it isn't
    # clear how to interpret it.
  end

  describe '.known_values' do
    it 'boxes the value for each path' do
      paths = [[:key, 0], [:key, 1]]
      object = { key: [10, 20] }

      values = described_class.known_values(paths, object: object)

      expect(values)
        .to(eq([V.known(10), V.known(20)]))
    end

    it 'boxes the value as sensitive when sensitive' do
      paths = [[:key, 0], [:key, 1]]
      object = { key: [10, 20] }
      sensitive = { key: [true, true] }

      values = described_class.known_values(
        paths, object: object, sensitive: sensitive
      )

      expect(values)
        .to(eq([V.known(10, sensitive: true),
                V.known(20, sensitive: true)]))
    end

    it 'boxes the value as non-sensitive when not sensitive' do
      paths = [[:key, 0], [:key, 1]]
      object = { key: [10, 20] }
      sensitive = {}

      values = described_class.known_values(
        paths, object: object, sensitive: sensitive
      )

      expect(values)
        .to(eq([V.known(10, sensitive: false),
                V.known(20, sensitive: false)]))
    end
  end

  describe '.unknown_values' do
    it 'boxes the value for each path' do
      paths = [[:key, 0], [:key, 1]]
      unknown = { key: [true, true] }

      values = described_class.unknown_values(paths, unknown: unknown)

      expect(values).to(eq([V.unknown, V.unknown]))
    end

    it 'returns nil when unknown is false at the path' do
      paths = [[:key, 0], [:key, 1]]
      unknown = { key: [false, false] }

      values = described_class.unknown_values(paths, unknown: unknown)

      expect(values).to(eq([nil, nil]))
    end

    it 'returns nil when unknown is missing at the path' do
      paths = [[:key, 0], [:key, 1]]
      unknown = {}

      values = described_class.unknown_values(paths, unknown: unknown)

      expect(values).to(eq([nil, nil]))
    end

    it 'boxes the value as sensitive when sensitive' do
      paths = [[:key, 0], [:key, 1]]
      unknown = { key: [true, true] }
      sensitive = { key: [true, true] }

      values = described_class.unknown_values(
        paths, unknown: unknown, sensitive: sensitive
      )

      expect(values)
        .to(eq([V.unknown(sensitive: true),
                V.unknown(sensitive: true)]))
    end

    it 'boxes the value as non-sensitive when not sensitive' do
      paths = [[:key, 0], [:key, 1]]
      unknown = { key: [true, true] }
      sensitive = {}

      values = described_class.unknown_values(
        paths, unknown: unknown, sensitive: sensitive
      )

      expect(values)
        .to(eq([V.unknown(sensitive: false),
                V.unknown(sensitive: false)]))
    end
  end
end