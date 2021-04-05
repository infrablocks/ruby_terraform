require_relative 'base'
require_relative 'values/boolean'

module RubyTerraform
  module Options
    class Boolean < Base
      include Values::Boolean

      def apply(builder)
        builder.with_option(switch, value)
      end
    end
  end
end
