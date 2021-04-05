require_relative 'base'
require_relative '../values/boolean'

module RubyTerraform
  module Options
    module Types
      class Boolean < Base
        include Values::Boolean

        def apply(builder)
          builder.with_option(name, value)
        end
      end
    end
  end
end
