# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Options
    module Values
      class Boolean < Base
        def resolve
          return nil if @value.nil?
          return @value if a_boolean?(@value)
          return true if true_as_string?(@value)

          false
        end

        def render
          resolve&.to_s
        end

        private

        def a_boolean?(value)
          value.is_a?(TrueClass) || value.is_a?(FalseClass)
        end

        def true_as_string?(value)
          value.respond_to?(:downcase) && value.downcase == 'true'
        end
      end
    end
  end
end
