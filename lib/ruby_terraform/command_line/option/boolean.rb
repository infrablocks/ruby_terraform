require_relative 'boolean_value'
require_relative 'base'

module RubyTerraform
  module CommandLine
    module Option
      class Boolean < Base
        include BooleanValue

        def add_to_subcommand(sub)
          sub.with_option(switch, value)
        end
      end
    end
  end
end
