module RubyTerraform
  module CommandLine
    module BooleanValueFunctionality
      def assign_option_value(value)
        @value = boolean_val(value)
      end

      def boolean_val(variable)
        return nil if variable.nil?
        return variable if variable.is_a?(TrueClass) || variable.is_a?(FalseClass)
        return true if variable.respond_to?(:upcase) && variable[0].upcase == 'T'

        false
      end
    end
  end
end
