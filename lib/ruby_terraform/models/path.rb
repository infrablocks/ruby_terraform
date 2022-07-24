# frozen_string_literal: true

require_relative '../value_equality'

module RubyTerraform
  module Models
    class Path
      extend Forwardable

      include Comparable
      include ValueEquality

      def_delegators(:@elements, :first, :last, :length, :empty?)

      attr_reader(:elements)

      def initialize(elements)
        @elements = elements.compact
      end

      def references_any_lists?
        elements.any? { |e| e.is_a?(Numeric) }
      end

      def references_any_maps?
        elements.any? { |e| e.is_a?(Symbol) }
      end

      def same_parent_collection?(other)
        return true if self == other

        left, right = diff(other)
        left.length == 1 && right.length == 1
      end

      def list_indices
        elements.each_with_index.inject([]) do |acc, element_index|
          element, index = element_index
          element.is_a?(Numeric) ? acc + [[index, element]] : acc
        end
      end

      def up_to_index(index)
        self.class.new(elements[0..index])
      end

      def append(element)
        self.class.new(elements + [element])
      end

      def drop(count = 1)
        self.class.new(elements.drop(count))
      end

      def diff(other)
        left, right = match_lengths(elements, other.elements)
        pairwise = left.zip(right)
        difference = pairwise.drop_while { |e| e[0] == e[1] }
        difference = difference.empty? ? [[], []] : difference.transpose
        difference.map { |e| self.class.new(e) }
      end

      def walk(&block)
        elements.inject(initial_walk_context) do |context, step|
          seen = context[:seen]
          remaining = context[:remaining]
          pointer = [seen, step, remaining]

          block.call(*pointer)

          next_walk_context(seen, step, remaining)
        end
      end

      def read(object, default: nil)
        return default if empty?

        result = object.dig(*elements)
        result.nil? ? default : result
      rescue NoMethodError, TypeError
        default
      end

      def <=>(other)
        return 0 if self == other

        left, right = diff(other)
        return -1 if left.empty?
        return 1 if right.empty?

        compare_numbers_before_symbols(left.first, right.first)
      end

      def state
        [elements]
      end

      def inspect
        elements.map(&:to_s).join(', ')
      end

      private

      def initial_walk_context
        { seen: self.class.new([]), remaining: drop(1) }
      end

      def next_walk_context(seen, step, remaining)
        { seen: seen.append(step), remaining: remaining.drop(1) }
      end

      def compare_numbers_before_symbols(left, right)
        return -1 if left.is_a?(Numeric) && right.is_a?(Symbol)
        return 1 if left.is_a?(Symbol) && right.is_a?(Numeric)

        left <=> right
      end

      def match_lengths(left, right)
        max_length = [left.count, right.count].max
        [
          pad_to_length(left, max_length),
          pad_to_length(right, max_length)
        ]
      end

      def pad_to_length(array, target_length)
        array.clone.fill(nil, array.count, target_length - array.count)
      end
    end
  end
end
