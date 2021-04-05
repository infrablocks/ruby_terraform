require_relative 'base'

module RubyTerraform
  module Commands
    class Get < Base
      def switches
        %w[-update -no-color]
      end

      def subcommands(_values)
        %w[get]
      end

      def arguments(values)
        [values[:directory]]
      end
    end
  end
end
