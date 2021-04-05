require_relative 'base'
require_relative 'values/boolean'

module RubyTerraform
  module Options
    class Flag < Base
      include Values::Boolean

      def apply(builder)
        value ? builder.with_flag(switch) : builder
      end
    end
  end
end
