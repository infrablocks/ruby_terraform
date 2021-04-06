# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Commands
    class Destroy < Base
      def options
        %w[
          -auto-approve
          -backup
          -force
          -no-color
          -state
          -target
          -var
          -var-file
        ]
      end

      def subcommands(_parameters)
        %w[destroy]
      end

      def arguments(parameters)
        [parameters[:directory]]
      end

      def parameter_defaults(_parameters)
        { vars: {}, var_files: [], targets: [] }
      end

      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
