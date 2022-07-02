# frozen_string_literal: true

require_relative '../value_equality'

module RubyTerraform
  module Models
    class KnownValue
      include ValueEquality

      def initialize(value, sensitive: false)
        @value = value
        @sensitive = sensitive
      end

      attr_reader :value

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
        "#{@value.inspect} (known, #{sensitive})"
      end
    end
  end
end
