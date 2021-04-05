require_relative 'base'

module RubyTerraform
  module Commands
    class Apply < Base
      def subcommands(_values)
        %w[apply]
      end

      # rubocop:disable Metrics/MethodLength
      def switches
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

      def option_default_values(_opts)
        { vars: {}, var_files: [], targets: [] }
      end

      def option_override_values(opts)
        { backup: opts[:no_backup] ? '-' : opts[:backup] }
      end
    end
  end
end
