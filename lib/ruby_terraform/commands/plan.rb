require_relative 'base'

module RubyTerraform
  module Commands
    class Plan < Base
      def options
        %w[
          -destroy
          -input
          -no-color
          -out
          -state
          -target
          -var
          -var-file
        ]
      end

      def subcommands(_parameters)
        %w[plan]
      end

      def arguments(parameters)
        [parameters[:directory]]
      end

      def parameter_defaults(_parameters)
        { vars: {}, var_files: [], targets: [] }
      end
    end
  end
end
