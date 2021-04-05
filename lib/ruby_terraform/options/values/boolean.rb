module RubyTerraform
  module Options
    module Values
      module Boolean
        def coerce_value(value)
          @value = to_boolean(value)
        end

        private

        def to_boolean(value)
          return nil if value.nil?
          return value if a_boolean?(value)
          return true if true_as_string?(value)

          false
        end

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
