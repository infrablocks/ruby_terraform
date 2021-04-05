module RubyTerraform
  module Options
    class Base
      def initialize(switch, value)
        @switch = switch
        coerce_value(value)
      end

      def apply(_builder)
        raise 'not implemented'
      end

      private

      attr_reader :switch, :value

      def coerce_value(value)
        @value = value
      end
    end
  end
end
