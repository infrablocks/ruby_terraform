require_relative 'boolean_value_functionality'
require_relative 'option'

module RubyTerraform
  module CommandLine
    class Flag < Option
      include BooleanValueFunctionality

      def add_option_to_subcommand(sub)
        if value.nil? || !value
          sub
        else
          sub.with_flag(switch)
        end
      end
    end
  end
end
