# frozen_string_literal: true

require_relative '../value_equality'

module RubyTerraform
  module Models
    class UnknownValue
      include ValueEquality

      def initialize(sensitive: false)
        @sensitive = sensitive
      end

      def known?
        false
      end

      def sensitive?
        @sensitive
      end

      def state
        [@sensitive]
      end

      def inspect
        sensitive = sensitive? ? 'sensitive' : 'non-sensitive'
        "? (unknown, #{sensitive})"
      end
    end
  end
end
