# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Layout/LineContinuationLeadingSpace
describe RubyTerraform::Models::Map do
  describe '#value' do
    it 'returns the underlying map with values still boxed' do
      value = { first: V.known(1), second: V.known(2) }
      map = described_class.new(value)

      expect(map.value).to(eq(value))
    end

    it 'returns the underlying map with symbol keys when provided as strings' do
      map = described_class.new(
        { 'first' => V.known(1), 'second' => V.known(2) }
      )

      expect(map.value).to(eq({ first: V.known(1), second: V.known(2) }))
    end
  end

  describe '#unbox' do
    it 'returns underlying map after unboxing scalar entries' do
      map = described_class.new(
        { first: V.known(1), second: V.known(2) }
      )

      expect(map.unbox).to(eq({ first: 1, second: 2 }))
    end

    it 'returns underlying map after unboxing list entries' do
      map = described_class.new(
        {
          first: V.list([V.known(1), V.known(2)]),
          second: V.list([V.known(3)])
        }
      )

      expect(map.unbox).to(eq({ first: [1, 2], second: [3] }))
    end

    it 'returns underlying map after unboxing map entries' do
      map = described_class.new(
        {
          first: V.map(
            {
              third: V.known(3),
              fourth: V.known(4)
            }
          ),
          second: V.map(
            {
              fifth: V.known(5)
            }
          )
        }
      )

      expect(map.unbox)
        .to(eq(
              {
                first: { third: 3, fourth: 4 },
                second: { fifth: 5 }
              }
            ))
    end

    it 'returns underlying map with symbol keys when provided as strings' do
      map = described_class.new(
        {
          'first' => V.map(
            {
              'third' => V.known(3),
              'fourth' => V.known(4)
            }
          ),
          'second' => V.map(
            {
              'fifth' => V.known(5)
            }
          )
        }
      )

      expect(map.unbox)
        .to(eq(
              {
                first: { third: 3, fourth: 4 },
                second: { fifth: 5 }
              }
            ))
    end
  end

  describe '#known?' do
    it 'returns true' do
      map = described_class.new(
        { key: V.known(1) }
      )

      expect(map).to(be_known)
    end
  end

  describe '#sensitive?' do
    it 'returns true when sensitive' do
      map = described_class.new(
        { key: V.known(1) },
        sensitive: true
      )

      expect(map).to(be_sensitive)
    end

    it 'returns false when not sensitive' do
      map = described_class.new(
        { key: V.known(1) },
        sensitive: false
      )

      expect(map).not_to(be_sensitive)
    end

    it 'returns false by default' do
      map = described_class.new({ key: V.known(1) })

      expect(map).not_to(be_sensitive)
    end
  end

  describe '#render' do
    it 'returns {} on one line when map is empty' do
      value = {}
      map = described_class.new(value)

      expect(map.render).to(eq('{}'))
    end

    it 'returns a string of the rendered scalar-valued entry over ' \
       'three lines when map has one scalar-valued entry' do
      key = :some_key
      value = V.known('some-value')
      map = described_class.new({ key => value })

      expect(map.render)
        .to(eq(
              "{\n" \
              "  some_key = \"some-value\"\n" \
              '}'
            ))
    end

    it 'returns a string of the rendered scalar-valued entries over ' \
       'many lines when map has many scalar-valued entries' do
      key1 = :some_attribute1
      key2 = :some_attribute2
      key3 = :some_attribute3
      value1 = V.known('some-value-1')
      value2 = V.known('some-value-2')
      value3 = V.known('some-value-3')

      map = described_class
            .new({ key1 => value1, key2 => value2, key3 => value3 })

      expect(map.render)
        .to(eq(
              "{\n" \
              "  some_attribute1 = \"some-value-1\"\n" \
              "  some_attribute2 = \"some-value-2\"\n" \
              "  some_attribute3 = \"some-value-3\"\n" \
              '}'
            ))
    end

    it 'returns a string of the rendered list-valued entries over ' \
       'many lines, correctly indented when map has many list-valued entries' do
      key1 = :some_attribute1
      key2 = :some_attribute2
      value1 = V.list([V.known('some-value-1'), V.known('some-value-2')])
      value2 = V.list([V.known('some-value-3'), V.known('some-value-4')])

      map = described_class
            .new({ key1 => value1, key2 => value2 })

      expect(map.render)
        .to(eq(
              "{\n" \
              "  some_attribute1 = [\n" \
              "    \"some-value-1\",\n" \
              "    \"some-value-2\"\n" \
              "  ]\n" \
              "  some_attribute2 = [\n" \
              "    \"some-value-3\",\n" \
              "    \"some-value-4\"\n" \
              "  ]\n" \
              '}'
            ))
    end

    it 'returns a string of the rendered map-valued entries over ' \
       'many lines, correctly indented when map has many map-valued entries' do
      key1 = :some_attribute1
      sub_key1 = :some_key1
      sub_key2 = :some_key2
      value1 = V.known('some-value-1')
      value2 = V.known('some-value-2')

      map = described_class
            .new({ key1 =>
                       described_class.new({
                                             sub_key1 => value1,
                                             sub_key2 => value2
                                           }) })

      expect(map.render)
        .to(eq(
              "{\n" \
              "  some_attribute1 = {\n" \
              "    some_key1 = \"some-value-1\"\n" \
              "    some_key2 = \"some-value-2\"\n" \
              "  }\n" \
              '}'
            ))
    end

    it 'returns a string of the rendered complex nested valued entries over ' \
       'many lines, correctly indented when map has many complex nested ' \
       'valued entries' do
      key1 = :some_attribute1
      sub_key1 = :some_key1
      sub_key2 = :some_key2
      value1 = V.known('some-value-1')
      value2 = V.known('some-value-2')
      child1 = described_class
               .new({
                      sub_key1 => value1,
                      sub_key2 => value2
                    })
      child2 = described_class
               .new({
                      sub_key1 => value1,
                      sub_key2 => value2
                    })
      list = V.list([child1, child2])

      map = described_class
            .new({ key1 => list })

      expect(map.render)
        .to(eq(
              "{\n" \
              "  some_attribute1 = [\n" \
              "    {\n" \
              "      some_key1 = \"some-value-1\"\n" \
              "      some_key2 = \"some-value-2\"\n" \
              "    },\n" \
              "    {\n" \
              "      some_key1 = \"some-value-1\"\n" \
              "      some_key2 = \"some-value-2\"\n" \
              "    }\n" \
              "  ]\n" \
              '}'
            ))
    end

    it 'adds single unit of extra indentation when level is 1' do
      map = described_class.new({ some_key: V.known('some-value') })

      expect(map.render(level: 1))
        .to(eq(
              "{\n" \
              "    some_key = \"some-value\"\n" \
              '  }'
            ))
    end

    it 'adds multiple units of extra indentation when level is ' \
       'greater than 1' do
      map = described_class.new({ some_key: V.known('some-value') })

      expect(map.render(level: 3))
        .to(eq(
              "{\n" \
              "        some_key = \"some-value\"\n" \
              '      }'
            ))
    end

    it 'uses the provided indent when specified' do
      map = described_class.new({ some_key: V.known('some-value') })

      expect(map.render(indent: '    '))
        .to(eq(
              "{\n" \
              "    some_key = \"some-value\"\n" \
              '}'
            ))
    end

    it 'correctly combines level and indent' do
      map = described_class.new({ some_key: V.known('some-value') })

      expect(map.render(level: 1, indent: '    '))
        .to(eq(
              "{\n" \
              "        some_key = \"some-value\"\n" \
              '    }'
            ))
    end

    it 'skips top-level braces and indentation when bare is true' do
      key1 = :some_attribute1
      sub_key1 = :some_key1
      sub_key2 = :some_key2
      value1 = V.known('some-value-1')
      value2 = V.known('some-value-2')
      child1 = described_class
               .new({
                      sub_key1 => value1,
                      sub_key2 => value2
                    })
      child2 = described_class
               .new({
                      sub_key1 => value1,
                      sub_key2 => value2
                    })
      list = V.list([child1, child2])

      map = described_class
            .new({ key1 => list })

      expect(map.render(bare: true))
        .to(eq(
              "some_attribute1 = [\n" \
              "  {\n" \
              "    some_key1 = \"some-value-1\"\n" \
              "    some_key2 = \"some-value-2\"\n" \
              "  },\n" \
              "  {\n" \
              "    some_key1 = \"some-value-1\"\n" \
              "    some_key2 = \"some-value-2\"\n" \
              "  }\n" \
              ']'
            ))
    end
  end

  describe '#==' do
    it 'returns true when the state and class are the same' do
      value1 = described_class.new({ some_key: 'some-value' })
      value2 = described_class.new({ some_key: 'some-value' })

      expect(value1).to(eq(value2))
    end

    it 'returns true when one provided string keys and the other symbol keys' do
      value1 = described_class.new({ 'some_key' => 'some-value' })
      value2 = described_class.new({ some_key: 'some-value' })

      expect(value1).to(eq(value2))
    end

    it 'returns false when the value is different' do
      value1 = described_class.new({ some_key: 'first-value' })
      value2 = described_class.new({ some_key: 'second-value' })

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when sensitive is different' do
      value1 = described_class.new(
        { some_key: 'some-value' }, sensitive: true
      )
      value2 = described_class.new(
        { some_key: 'some-value' }, sensitive: false
      )

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when the classes are different' do
      value1 = described_class.new(
        { some_key: 'some-value' }, sensitive: true
      )
      value2 = Class.new(described_class)
                    .new({ some_key: 'some-value' }, sensitive: true)

      expect(value1).not_to(eq(value2))
    end
  end

  describe '#hash' do
    it 'has the same result when the state and class are the same' do
      value1 = described_class.new({ some_key: 'some-value' })
      value2 = described_class.new({ some_key: 'some-value' })

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has a different result when the value is different' do
      value1 = described_class.new({ some_key: 'first-value' })
      value2 = described_class.new({ some_key: 'second-value' })

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when sensitive is different' do
      value1 = described_class.new(
        { some_key: 'some-value' }, sensitive: true
      )
      value2 = described_class.new(
        { some_key: 'some-value' }, sensitive: false
      )

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when the classes are different' do
      value1 = described_class.new(
        { some_key: 'some-value' }, sensitive: true
      )
      value2 = Class.new(described_class).new(
        { some_key: 'some-value' }, sensitive: true
      )

      expect(value1.hash).not_to(eq(value2.hash))
    end
  end

  describe '#inspect' do
    it 'returns the underlying value with non-sensitive by default' do
      map = described_class.new(
        { key: V.known(1) }
      )

      expect(map.inspect)
        .to(eq('{:key=>1 (known, non-sensitive)} (non-sensitive)'))
    end

    it 'returns the underlying value with non-sensitive when not sensitive' do
      map = described_class.new(
        { key: V.known(1) },
        sensitive: false
      )

      expect(map.inspect)
        .to(eq('{:key=>1 (known, non-sensitive)} (non-sensitive)'))
    end

    it 'returns the underlying value with sensitive when sensitive' do
      map = described_class.new(
        { key: V.known(1) },
        sensitive: true
      )

      expect(map.inspect)
        .to(eq('{:key=>1 (known, non-sensitive)} (sensitive)'))
    end
  end
end
# rubocop:enable Layout/LineContinuationLeadingSpace
