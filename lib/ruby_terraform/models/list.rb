# frozen_string_literal: true

require_relative '../value_equality'

module RubyTerraform
  module Models
    class List
      extend Forwardable

      include Enumerable
      include ValueEquality

      def_delegators(
        :@value,
        :to_a, :to_h, :to_ary,
        :[], :[]=, :at, :fetch, :first, :last,
        :concat, :union, :difference, :intersection, :intersect?,
        :<<, :push, :append, :pop, :shift, :unshift, :insert,
        :each, :each_index, :reverse_each, :length, :size, :empty?,
        :find_index, :index, :rindex, :join,
        :reverse, :reverse!, :rotate, :rotate!, :sort, :sort!, :sort_by!,
        :collect, :collect!, :map, :map!, :select, :select!, :filter, :filter!,
        :keep_if, :values_at, :delete, :delete_at, :delete_if,
        :reject, :reject!, :zip, :transpose, :replace, :clear, :fill, :include?,
        :<=>, :slice, :slice!, :assoc, :rassoc, :+, :*, :-, :&, :|, :max, :min,
        :minmax, :uniq, :uniq!, :compact, :compact!, :flatten, :flatten!,
        :count, :cycle,
        :permutation, :combination,
        :repeated_permutation, :repeated_combination,
        :product, :take, :take_while, :drop, :drop_while,
        :bsearch, :bsearch_index, :any?, :all?, :none?, :one?, :dig, :sum,
        :deconstruct, :append, :prepend, :shuffle!, :shuffle, :sample, :pack
      )

      def initialize(value, sensitive: false)
        @value = value
        @sensitive = sensitive
      end

      attr_reader :value

      def sensitive?
        @sensitive
      end

      def state
        [@value, @sensitive]
      end

      def inspect
        sensitive = sensitive? ? 'sensitive' : 'non-sensitive'
        "#{value.inspect} (#{sensitive})"
      end
      alias to_s inspect
    end
  end
end
