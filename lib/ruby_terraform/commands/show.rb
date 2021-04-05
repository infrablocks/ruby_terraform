require_relative 'base'

module RubyTerraform
  module Commands
    class Show < Base
      def switches
        %w[
          -json
          -module-depth
          -no-color
        ]
      end

      def subcommands(_values)
        %w[show]
      end

      def arguments(values)
        [values[:path] || values[:directory]]
      end
    end
  end
end
