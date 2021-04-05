require_relative 'base'

module RubyTerraform
  module Commands
    class Format < Base
      def switches
        %w[
          -check
          -diff
          -list
          -no-color
          -recursive
          -write
        ]
      end

      def subcommands(_values)
        %w[fmt]
      end

      def arguments(values)
        [values[:directory]]
      end
    end
  end
end
