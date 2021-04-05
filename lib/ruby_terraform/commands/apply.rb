require_relative 'base'

module RubyTerraform
  module Commands
    class Apply < Base
      def subcommands(_values)
        %w[apply]
      end

      # rubocop:disable Metrics/MethodLength
      def options
        %w[
          -auto-approve
          -backup
          -input
          -lock
          -lock-timeout
          -no-color
          -state
          -target
          -var
          -var-file
        ]
      end
      # rubocop:enable Metrics/MethodLength

      def arguments(values)
        [values[:plan] || values[:directory]]
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
