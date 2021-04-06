# frozen_string_literal: true

module RubyTerraform
  module Options
    module Types
      class Base
        def initialize(name, value)
          @name = name
          coerce_value(value)
        end

        def apply(_builder)
          raise 'not implemented'
        end

        private

        attr_reader :name, :value

        def coerce_value(value)
          @value = value
        end
      end
    end
  end
end
