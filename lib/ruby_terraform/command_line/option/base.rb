module RubyTerraform
  module CommandLine
    module Option
      class Base
        def initialize(switch, value)
          @switch = switch
          coerce_value(value)
        end

        def add_to_subcommand(_sub)
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
end
