require_relative 'boolean_value_functionality'
require_relative 'option'

module RubyTerraform
  module CommandLine
    class BooleanOption < Option
      include BooleanValueFunctionality

      def add_option_to_subcommand(sub)
        if value.nil?
          sub
        else
          sub.with_option(switch, value)
        end
      end
    end
  end
end
