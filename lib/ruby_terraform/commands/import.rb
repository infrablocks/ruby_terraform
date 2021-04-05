require_relative 'base'

module RubyTerraform
  module Commands
    class Import < Base
      def options
        %w[
          -config
          -backup
          -input
          -no-color
          -state
          -var
          -var-file
        ]
      end

      def subcommands(_parameters)
        %w[import]
      end

      def arguments(parameters)
        [parameters[:address], parameters[:id]]
      end

      def parameter_defaults(_parameters)
        { vars: {}, var_files: [] }
      end

      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
