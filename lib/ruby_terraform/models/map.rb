# frozen_string_literal: true

require_relative '../value_equality'

module RubyTerraform
  module Models
    class Map
      extend Forwardable

      include Enumerable
      include ValueEquality

      def_delegators(
        :@value,
        :rehash, :to_hash, :to_h, :to_a, :to_proc,
        :[], :fetch, :[]=, :store, :default, :default=,
        :default_proc, :default_proc=, :key, :size, :length, :empty?,
        :each_value, :each_key, :each_pair, :each,
        :transform_keys, :transform_keys!,
        :transform_values, :transform_values!,
        :keys, :values, :values_at, :fetch_values,
        :shift, :delete, :delete_if, :keep_if,
        :select, :select!, :filter, :filter!, :reject, :reject!,
        :slice, :except, :clear, :invert, :update, :replace,
        :merge!, :merge, :assoc, :rassoc, :flatten, :compact, :compact!,
        :include?, :member?, :has_key?, :has_value?, :key?, :value?,
        :compare_by_identity, :compare_by_identity?, :any?, :dig,
        :<=, :<, :>=, :>, :deconstruct_keys
      )

      def initialize(value, sensitive: false)
        @value = value
        @sensitive = sensitive
      end

      attr_reader :value

      def unbox
        value.transform_values(&:unbox)
      end

      def known?
        true
      end

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
