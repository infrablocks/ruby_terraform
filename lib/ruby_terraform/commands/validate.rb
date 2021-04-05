require_relative 'base'

module RubyTerraform
  module Commands
    class Validate < Base
      def options
        %w[
          -check-variables
          -json
          -no-color
          -state
          -var
          -var-file
        ]
      end

      def subcommands(_parameters)
        %w[validate]
      end

      def arguments(parameters)
        [parameters[:directory]]
      end

      def parameter_defaults(_parameters)
        { vars: {}, var_files: [] }
      end
    end
  end
end
