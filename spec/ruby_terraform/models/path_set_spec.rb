# frozen_string_literal: true

require 'spec_helper'

describe RubyTerraform::Models::PathSet do
  describe '.extract_from' do
    it 'extracts all paths from a hash of scalars' do
      hash = {
        first: 1,
        second: '2',
        third: false
      }
      path_set = described_class.extract_from(hash)

      expect(path_set)
        .to(eq(M::PathSet.new(
                 [
                   M::Path.new([:first]),
                   M::Path.new([:second]),
                   M::Path.new([:third])
                 ]
               )))
    end

    it 'extracts all paths from a hash of arrays' do
      hash = {
        first: [1, 2, 3],
        second: %w[value1 value2]
      }
      path_set = described_class.extract_from(hash)

      expect(path_set)
        .to(eq(M::PathSet.new(
                 [
                   M::Path.new([:first, 0]),
                   M::Path.new([:first, 1]),
                   M::Path.new([:first, 2]),
                   M::Path.new([:second, 0]),
                   M::Path.new([:second, 1])
                 ]
               )))
    end

    it 'extracts all paths from a hash of hashes' do
      hash = {
        first: {
          a: 1,
          b: 2
        },
        second: {
          c: 3,
          d: 4
        }
      }
      path_set = described_class.extract_from(hash)

      expect(path_set)
        .to(eq(M::PathSet.new(
                 [
                   M::Path.new(%i[first a]),
                   M::Path.new(%i[first b]),
                   M::Path.new(%i[second c]),
                   M::Path.new(%i[second d])
                 ]
               )))
    end

    it 'extracts all paths from a nested complex hash' do
      hash = {
        a: {
          b: [1, 2, 3],
          c: [
            { d: 'value1', e: 'value2' },
            { d: 'value3', e: 'value4' }
          ],
          f: true
        }
      }
      path_set = described_class.extract_from(hash)

      expect(path_set)
        .to(eq(M::PathSet.new(
                 [
                   M::Path.new([:a, :b, 0]),
                   M::Path.new([:a, :b, 1]),
                   M::Path.new([:a, :b, 2]),
                   M::Path.new([:a, :c, 0, :d]),
                   M::Path.new([:a, :c, 0, :e]),
                   M::Path.new([:a, :c, 1, :d]),
                   M::Path.new([:a, :c, 1, :e]),
                   M::Path.new(%i[a f])
                 ]
               )))
    end

    it 'extracts no paths from an empty hash' do
      hash = {}
      path_set = described_class.extract_from(hash)

      expect(path_set).to(eq(M::PathSet.empty))
    end

    it 'extracts all paths from an array of scalars' do
      array = [1, 2, 3]
      path_set = described_class.extract_from(array)

      expect(path_set)
        .to(eq(M::PathSet.new(
                 [
                   M::Path.new([0]),
                   M::Path.new([1]),
                   M::Path.new([2])
                 ]
               )))
    end

    it 'extracts all paths from an array of arrays' do
      array = [[1, 2, 3], [4, 5, 6]]
      path_set = described_class.extract_from(array)

      expect(path_set)
        .to(eq(M::PathSet.new(
                 [
                   M::Path.new([0, 0]),
                   M::Path.new([0, 1]),
                   M::Path.new([0, 2]),
                   M::Path.new([1, 0]),
                   M::Path.new([1, 1]),
                   M::Path.new([1, 2])
                 ]
               )))
    end

    it 'extracts all paths from an array of hashes' do
      array = [{ a: 1, b: 2 }, { c: 3, d: 4 }]
      path_set = described_class.extract_from(array)

      expect(path_set)
        .to(eq(M::PathSet.new(
                 [
                   M::Path.new([0, :a]),
                   M::Path.new([0, :b]),
                   M::Path.new([1, :c]),
                   M::Path.new([1, :d])
                 ]
               )))
    end

    it 'extracts all paths from a nested complex array' do
      array = [
        {
          b: [1, 2, 3],
          c: [
            { d: 'value1', e: 'value2' },
            { d: 'value3', e: 'value4' }
          ]
        },
        {
          f: true
        }
      ]
      path_set = described_class.extract_from(array)

      expect(path_set)
        .to(eq(M::PathSet.new(
                 [
                   M::Path.new([0, :b, 0]),
                   M::Path.new([0, :b, 1]),
                   M::Path.new([0, :b, 2]),
                   M::Path.new([0, :c, 0, :d]),
                   M::Path.new([0, :c, 0, :e]),
                   M::Path.new([0, :c, 1, :d]),
                   M::Path.new([0, :c, 1, :e]),
                   M::Path.new([1, :f])
                 ]
               )))
    end

    it 'extracts no paths from an empty array' do
      array = []
      path_set = described_class.extract_from(array)

      expect(path_set).to(eq(M::PathSet.empty))
    end

    it 'converts string path segments into symbols when object of objects' do
      object = {
        'first' => {
          'a' => 1,
          'b' => 2
        },
        'second' => {
          'c' => 3,
          'd' => 4
        }
      }
      paths = described_class.extract_from(object)

      expect(paths)
        .to(eq(M::PathSet.new(
                 [
                   M::Path.new(%i[first a]),
                   M::Path.new(%i[first b]),
                   M::Path.new(%i[second c]),
                   M::Path.new(%i[second d])
                 ]
               )))
    end

    it 'converts string path segments into symbols when object of lists' do
      object = {
        'first' => [1, 2, 3],
        'second' => %w[value1 value2]
      }
      paths = described_class.extract_from(object)

      expect(paths)
        .to(eq(M::PathSet.new(
                 [
                   M::Path.new([:first, 0]),
                   M::Path.new([:first, 1]),
                   M::Path.new([:first, 2]),
                   M::Path.new([:second, 0]),
                   M::Path.new([:second, 1])
                 ]
               )))
    end
  end

  describe '.empty' do
    it 'returns a path set containing no paths' do
      path_set = described_class.empty

      expect(path_set.paths).to(eq([]))
    end
  end

  describe '#empty?' do
    it 'returns true if it contains no paths' do
      path_set = described_class.empty

      expect(path_set.empty?).to(be(true))
    end

    it 'returns false if it contains paths' do
      path_set = described_class.new([M::Path.new(%i[a b])])

      expect(path_set.empty?).to(be(false))
    end
  end

  describe '#gaps' do
    it 'returns an empty path set when there are no gaps in a top-level ' \
       'array' do
      initial_path_set = described_class.new(
        [
          M::Path.new([0]),
          M::Path.new([1]),
          M::Path.new([2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.empty

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first item in a ' \
       'top-level array' do
      initial_path_set = described_class.new(
        [
          M::Path.new([1]),
          M::Path.new([2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([0])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle item in a ' \
       'top-level array' do
      initial_path_set = described_class.new(
        [
          M::Path.new([0]),
          M::Path.new([2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first items in a ' \
       'top-level array' do
      initial_path_set = described_class.new(
        [
          M::Path.new([2]),
          M::Path.new([3])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([0]),
          M::Path.new([1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle items in a ' \
       'top-level array' do
      initial_path_set = described_class.new(
        [
          M::Path.new([0]),
          M::Path.new([3])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([1]),
          M::Path.new([2])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns an empty path set when there are no gaps in an ' \
       'array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0]),
          M::Path.new([:attribute, 1]),
          M::Path.new([:attribute, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.empty

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first item in an ' \
       'array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 1]),
          M::Path.new([:attribute, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle item in an ' \
       'array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0]),
          M::Path.new([:attribute, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first items in an ' \
       'array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 2]),
          M::Path.new([:attribute, 3])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0]),
          M::Path.new([:attribute, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle items in an ' \
       'array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0]),
          M::Path.new([:attribute, 3])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 1]),
          M::Path.new([:attribute, 2])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns an empty path set when there are no gaps in a' \
       'nested array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 0, 1]),
          M::Path.new([:attribute, 0, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.empty

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first item in a ' \
       'nested array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 1]),
          M::Path.new([:attribute, 0, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle item in a ' \
       'nested array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 0, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first items in a ' \
       'nested array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 2]),
          M::Path.new([:attribute, 0, 3])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 0, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle items in a ' \
       'nested array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 0, 3])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 1]),
          M::Path.new([:attribute, 0, 2])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns an empty path set when there are no gaps in multiple' \
       'nested arrays within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 0, 1]),
          M::Path.new([:attribute, 0, 2]),
          M::Path.new([:attribute, 1, 0]),
          M::Path.new([:attribute, 1, 1]),
          M::Path.new([:attribute, 1, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.empty

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first item in multiple ' \
       'nested arrays within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 1]),
          M::Path.new([:attribute, 1, 1])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 1, 0])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle item in multiple ' \
       'nested arrays within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 0, 2]),
          M::Path.new([:attribute, 1, 0]),
          M::Path.new([:attribute, 1, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 1]),
          M::Path.new([:attribute, 1, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first items in multiple ' \
       'nested arrays within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 2]),
          M::Path.new([:attribute, 1, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 0, 1]),
          M::Path.new([:attribute, 1, 0]),
          M::Path.new([:attribute, 1, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle items in multiple ' \
       'nested arrays within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 0, 3]),
          M::Path.new([:attribute, 1, 0]),
          M::Path.new([:attribute, 1, 3])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 1]),
          M::Path.new([:attribute, 0, 2]),
          M::Path.new([:attribute, 1, 1]),
          M::Path.new([:attribute, 1, 2])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns an empty path set when there are no gaps in a' \
       'multi-level nested array' do
      initial_path_set = described_class.new(
        [
          M::Path.new([0]),
          M::Path.new([1]),
          M::Path.new([2, 0]),
          M::Path.new([2, 1])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.empty

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first item at multiple ' \
       'levels within a nested array' do
      initial_path_set = described_class.new(
        [
          M::Path.new([1, 1]),
          M::Path.new([2, 1])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([0]),
          M::Path.new([1, 0]),
          M::Path.new([2, 0])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle item at multiple ' \
       'levels within a nested array' do
      initial_path_set = described_class.new(
        [
          M::Path.new([0, 0]),
          M::Path.new([0, 2]),
          M::Path.new([2, 0]),
          M::Path.new([2, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([0, 1]),
          M::Path.new([1]),
          M::Path.new([2, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first items at multiple ' \
       'levels within a nested array' do
      initial_path_set = described_class.new(
        [
          M::Path.new([2, 2]),
          M::Path.new([3, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([0]),
          M::Path.new([1]),
          M::Path.new([2, 0]),
          M::Path.new([2, 1]),
          M::Path.new([3, 0]),
          M::Path.new([3, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle items at multiple ' \
       'levels within a nested array' do
      initial_path_set = described_class.new(
        [
          M::Path.new([0, 0]),
          M::Path.new([0, 3]),
          M::Path.new([3, 0]),
          M::Path.new([3, 3])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([0, 1]),
          M::Path.new([0, 2]),
          M::Path.new([1]),
          M::Path.new([2]),
          M::Path.new([3, 1]),
          M::Path.new([3, 2])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns an empty path set when there are no gaps at any level ' \
       'within a nested array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0]),
          M::Path.new([:attribute, 1]),
          M::Path.new([:attribute, 2, 0]),
          M::Path.new([:attribute, 2, 1])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.empty

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first item at multiple ' \
       'levels within a nested array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 1, 1]),
          M::Path.new([:attribute, 2, 1])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0]),
          M::Path.new([:attribute, 1, 0]),
          M::Path.new([:attribute, 2, 0])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle item at multiple ' \
       'levels within a nested array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 0, 2]),
          M::Path.new([:attribute, 2, 0]),
          M::Path.new([:attribute, 2, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 1]),
          M::Path.new([:attribute, 1]),
          M::Path.new([:attribute, 2, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first items at multiple ' \
       'levels within a nested array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 2, 2]),
          M::Path.new([:attribute, 3, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0]),
          M::Path.new([:attribute, 1]),
          M::Path.new([:attribute, 2, 0]),
          M::Path.new([:attribute, 2, 1]),
          M::Path.new([:attribute, 3, 0]),
          M::Path.new([:attribute, 3, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle items at multiple ' \
       'levels within a nested array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 0]),
          M::Path.new([:attribute, 0, 3]),
          M::Path.new([:attribute, 3, 0]),
          M::Path.new([:attribute, 3, 3])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, 1]),
          M::Path.new([:attribute, 0, 2]),
          M::Path.new([:attribute, 1]),
          M::Path.new([:attribute, 2]),
          M::Path.new([:attribute, 3, 1]),
          M::Path.new([:attribute, 3, 2])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns an empty path set when there are no gaps in an' \
       'array within a hash within an array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, :key, 0]),
          M::Path.new([:attribute, 0, :key, 1]),
          M::Path.new([:attribute, 0, :key, 2]),
          M::Path.new([:attribute, 1, :key, 0]),
          M::Path.new([:attribute, 1, :key, 1]),
          M::Path.new([:attribute, 1, :key, 2]),
          M::Path.new([:attribute, 2, :key, 0]),
          M::Path.new([:attribute, 2, :key, 1]),
          M::Path.new([:attribute, 2, :key, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.empty

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first item in an array ' \
       'within a hash within an array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 1, :key, 1])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0]),
          M::Path.new([:attribute, 1, :key, 0])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle item in an array ' \
       'within a hash within an array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, :key, 0]),
          M::Path.new([:attribute, 0, :key, 2]),
          M::Path.new([:attribute, 2, :key, 0]),
          M::Path.new([:attribute, 2, :key, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, :key, 1]),
          M::Path.new([:attribute, 1]),
          M::Path.new([:attribute, 2, :key, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing first items in array ' \
       'within a hash within an array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 2, :key, 2])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0]),
          M::Path.new([:attribute, 1]),
          M::Path.new([:attribute, 2, :key, 0]),
          M::Path.new([:attribute, 2, :key, 1])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end

    it 'returns a path set representing the missing middle items in an array ' \
       'within a hash within an array within a hash' do
      initial_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, :key, 0]),
          M::Path.new([:attribute, 0, :key, 3]),
          M::Path.new([:attribute, 3, :key, 0]),
          M::Path.new([:attribute, 3, :key, 3])
        ]
      )
      actual_gaps_path_set = initial_path_set.gaps

      expected_gaps_path_set = described_class.new(
        [
          M::Path.new([:attribute, 0, :key, 1]),
          M::Path.new([:attribute, 0, :key, 2]),
          M::Path.new([:attribute, 1]),
          M::Path.new([:attribute, 2]),
          M::Path.new([:attribute, 3, :key, 1]),
          M::Path.new([:attribute, 3, :key, 2])
        ]
      )

      expect(actual_gaps_path_set).to(eq(expected_gaps_path_set))
    end
  end
end
