require_relative 'base'

module RubyTerraform
  module Commands
    class Validate < Base
      def switches
        %w[
          -check-variables
          -json
          -no-color
          -state
          -var
          -var-file
        ]
      end

      def subcommands(_values)
        %w[validate]
      end

      def arguments(values)
        [values[:directory]]
      end

      def option_default_values(_opts)
        { vars: {}, var_files: [] }
      end
    end
  end
end
