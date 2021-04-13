# frozen_string_literal: true

require_relative 'values/boolean'
require_relative 'values/string'
require_relative 'values/complex'
require_relative 'values/key_value'

module RubyTerraform
  module Options
    module Values
      def self.boolean(value)
        Boolean.new(value)
      end

      def self.string(value)
        String.new(value)
      end

      def self.complex(value)
        Complex.new(value)
      end

      def self.key_value(key, value)
        KeyValue.new(key, value)
      end

      def self.resolve(type)
        case type
        when :string then Values::String
        when :boolean then Values::Boolean
        when :complex then Values::Complex
        when :key_value then Values::KeyValue
        else type
        end
      end
    end
  end
end
