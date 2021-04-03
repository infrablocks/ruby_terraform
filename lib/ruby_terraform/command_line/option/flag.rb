require_relative 'boolean_value'
require_relative 'base'

module RubyTerraform
  module CommandLine
    module Option
      class Flag < Base
        include BooleanValue

        def add_to_subcommand(sub)
          value ? sub.with_flag(switch) : sub
        end
      end
    end
  end
end
