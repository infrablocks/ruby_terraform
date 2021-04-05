require_relative 'base'

module RubyTerraform
  module Commands
    class Destroy < Base
      def switches
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

      def subcommands(_values)
        %w[destroy]
      end

      def arguments(values)
        [values[:directory]]
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
