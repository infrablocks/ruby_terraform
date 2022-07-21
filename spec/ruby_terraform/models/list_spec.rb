# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Layout/LineContinuationLeadingSpace
describe RubyTerraform::Models::List do
  describe '#value' do
    it 'returns the underlying array with values still boxed' do
      value = [V.known(1), V.known(2), V.known(3)]
      list = described_class.new(
        value,
        sensitive: true
      )

      expect(list.value).to(eq(value))
    end
  end

  describe '#unbox' do
    it 'returns underlying array after unboxing scalar items' do
      list = described_class.new(
        [V.known(1), V.known(2), V.known(3)],
        sensitive: true
      )

      expect(list.unbox).to(eq([1, 2, 3]))
    end

    it 'returns underlying array after unboxing list items' do
      list = described_class.new(
        [V.list([V.known(1), V.known(2)]), V.list([V.known(3)])],
        sensitive: true
      )

      expect(list.unbox).to(eq([[1, 2], [3]]))
    end

    it 'returns underlying array after unboxing map items' do
      list = described_class.new(
        [
          V.map(
            {
              first: V.known(1),
              second: V.known(2)
            }
          ),
          V.map(
            {
              third: V.known(3)
            }
          )
        ],
        sensitive: true
      )

      expect(list.unbox).to(eq([{ first: 1, second: 2 }, { third: 3 }]))
    end
  end

  describe '#known?' do
    it 'returns true' do
      list = described_class.new(
        [V.known(1), V.known(2), V.known(3)],
        sensitive: true
      )

      expect(list).to(be_known)
    end
  end

  describe '#sensitive?' do
    it 'returns true when sensitive' do
      list = described_class.new(
        [V.known(1), V.known(2), V.known(3)],
        sensitive: true
      )

      expect(list).to(be_sensitive)
    end

    it 'returns false when not sensitive' do
      list = described_class.new(
        [V.known(1), V.known(2), V.known(3)],
        sensitive: false
      )

      expect(list).not_to(be_sensitive)
    end

    it 'returns false by default' do
      list = described_class.new(
        [V.known(1), V.known(2), V.known(3)]
      )

      expect(list).not_to(be_sensitive)
    end
  end

  describe '#render' do
    it 'returns [] on one line when list is empty' do
      value = []
      list = described_class.new(value)

      expect(list.render).to(eq('[]'))
    end

    it 'returns a string of the rendered scalar item over three lines ' \
       'when list has one scalar item' do
      item = V.known('some-value')
      value = [item]
      list = described_class.new(value)

      expect(list.render)
        .to(eq(
              "[\n" \
              "  #{item.render}\n" \
              ']'
            ))
    end

    it 'returns a string of the rendered scalar items over many lines ' \
       'when list has many items' do
      item1 = V.known('some-value-1')
      item2 = V.known('some-value-2')
      item3 = V.known('some-value-3')
      value = [item1, item2, item3]
      list = described_class.new(value)

      expect(list.render)
        .to(eq(
              "[\n" \
              "  #{item1.render},\n" \
              "  #{item2.render},\n" \
              "  #{item3.render}\n" \
              ']'
            ))
    end

    it 'returns a string of the rendered list-valued items over ' \
       'many lines, correctly indented when list has many list-valued ' \
       'entries' do
      value1 = V.list([V.known('some-value-1'), V.known('some-value-2')])
      value2 = V.list([V.known('some-value-3'), V.known('some-value-4')])

      list = described_class.new([value1, value2])

      expect(list.render)
        .to(eq(
              "[\n" \
              "  [\n" \
              "    \"some-value-1\",\n" \
              "    \"some-value-2\"\n" \
              "  ],\n" \
              "  [\n" \
              "    \"some-value-3\",\n" \
              "    \"some-value-4\"\n" \
              "  ]\n" \
              ']'
            ))
    end

    it 'returns a string of the rendered map-valued items over ' \
       'many lines, correctly indented when list has many map-valued entries' do
      sub_key1 = :some_key1
      sub_key2 = :some_key2
      value1 = V.known('some-value-1')
      value2 = V.known('some-value-2')
      item1 = V.map({
                      sub_key1 => value1,
                      sub_key2 => value2
                    })
      item2 = V.map({
                      sub_key1 => value1,
                      sub_key2 => value2
                    })

      list = described_class.new([item1, item2])

      expect(list.render)
        .to(eq(
              "[\n" \
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

    it 'returns a string of the rendered complex nested valued items over ' \
       'many lines, correctly indented when list has many complex nested ' \
       'valued items' do
      sub_key1 = :some_key1
      sub_key2 = :some_key2
      value1 = V.known('some-value-1')
      value2 = V.known('some-value-2')
      child1 = V.map({
                       sub_key1 => value1,
                       sub_key2 => value2
                     })
      child2 = V.map({
                       sub_key1 => value1,
                       sub_key2 => value2
                     })
      item1 = V.list([child1, child2])

      list = described_class.new([item1])

      expect(list.render)
        .to(eq(
              "[\n" \
              "  [\n" \
              "    {\n" \
              "      some_key1 = \"some-value-1\"\n" \
              "      some_key2 = \"some-value-2\"\n" \
              "    },\n" \
              "    {\n" \
              "      some_key1 = \"some-value-1\"\n" \
              "      some_key2 = \"some-value-2\"\n" \
              "    }\n" \
              "  ]\n" \
              ']'
            ))
    end

    it 'correctly renders omitted values in lists' do
      value1 = V.omitted
      value2 = V.known('some-value-1')
      value3 = V.known('some-value-2')
      value4 = V.omitted

      list = described_class.new([value1, value2, value3, value4])

      expect(list.render)
        .to(eq(
              "[\n" \
              "  ...,\n" \
              "  \"some-value-1\",\n" \
              "  \"some-value-2\",\n" \
              "  ...\n" \
              ']'
            ))
    end

    it 'adds single unit of extra indentation when level is 1' do
      item = V.known('some-value')
      value = [item]
      list = described_class.new(value)

      expect(list.render(level: 1))
        .to(eq(
              "[\n" \
              "    #{item.render}\n" \
              '  ]'
            ))
    end

    it 'adds multiple units of extra indentation when level is ' \
       'greater than 1' do
      item = V.known('some-value')
      value = [item]
      list = described_class.new(value)

      expect(list.render(level: 3))
        .to(eq(
              "[\n" \
              "        #{item.render}\n" \
              '      ]'
            ))
    end

    it 'uses the provided indent when specified' do
      item = V.known('some-value')
      value = [item]
      list = described_class.new(value)

      expect(list.render(indent: '    '))
        .to(eq(
              "[\n" \
              "    #{item.render}\n" \
              ']'
            ))
    end

    it 'correctly combines level and indent' do
      item = V.known('some-value')
      value = [item]
      list = described_class.new(value)

      expect(list.render(level: 1, indent: '    '))
        .to(eq(
              "[\n" \
              "        #{item.render}\n" \
              '    ]'
            ))
    end
  end

  describe '#==' do
    it 'returns true when the state and class are the same' do
      value1 = described_class.new(%w[some-value-1 some-value-2])
      value2 = described_class.new(%w[some-value-1 some-value-2])

      expect(value1).to(eq(value2))
    end

    it 'returns false when the value is different' do
      value1 = described_class.new(%w[some-value-1 some-value-2])
      value2 = described_class.new(%w[some-value-2 some-value-3])

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when sensitive is different' do
      value1 = described_class.new(
        %w[some-value-1 some-value-2], sensitive: true
      )
      value2 = described_class.new(
        %w[some-value-1 some-value-2], sensitive: false
      )

      expect(value1).not_to(eq(value2))
    end

    it 'returns false when the classes are different' do
      value1 = described_class.new(
        %w[some-value-1 some-value-2], sensitive: true
      )
      value2 = Class.new(described_class)
                    .new(%w[some-value-1 some-value-2], sensitive: true)

      expect(value1).not_to(eq(value2))
    end
  end

  describe '#hash' do
    it 'has the same result when the state and class are the same' do
      value1 = described_class.new(%w[some-value-1 some-value-2])
      value2 = described_class.new(%w[some-value-1 some-value-2])

      expect(value1.hash).to(eq(value2.hash))
    end

    it 'has a different result when the value is different' do
      value1 = described_class.new(%w[some-value-1 some-value-2])
      value2 = described_class.new(%w[some-value-2 some-value-3])

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when sensitive is different' do
      value1 = described_class.new(
        %w[some-value-1 some-value-2], sensitive: true
      )
      value2 = described_class.new(
        %w[some-value-1 some-value-2], sensitive: false
      )

      expect(value1.hash).not_to(eq(value2.hash))
    end

    it 'has a different result when the classes are different' do
      value1 = described_class.new(
        %w[some-value-1 some-value-2], sensitive: true
      )
      value2 = Class.new(described_class).new(
        %w[some-value-1 some-value-2], sensitive: true
      )

      expect(value1.hash).not_to(eq(value2.hash))
    end
  end

  describe '#inspect' do
    it 'returns the underlying value with non-sensitive by default' do
      list = described_class.new(
        [V.known(1)]
      )

      expect(list.inspect)
        .to(eq('[1 (known, non-sensitive)] (non-sensitive)'))
    end

    it 'returns the underlying value with non-sensitive when not sensitive' do
      list = described_class.new(
        [V.known(1)],
        sensitive: false
      )

      expect(list.inspect)
        .to(eq('[1 (known, non-sensitive)] (non-sensitive)'))
    end

    it 'returns the underlying value with sensitive when sensitive' do
      list = described_class.new(
        [V.known(1)],
        sensitive: true
      )

      expect(list.inspect)
        .to(eq('[1 (known, non-sensitive)] (sensitive)'))
    end
  end
end
# rubocop:enable Layout/LineContinuationLeadingSpace
