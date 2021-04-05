require_relative 'base'

module RubyTerraform
  module Commands
    class Import < Base
      def switches
        %w[-config -backup -input -no-color -state -var -var-file]
      end

      def subcommands(_values)
        %w[import]
      end

      def arguments(values)
        [values[:address], values[:id]]
      end

      def option_default_values(_opts)
        { vars: {}, var_files: [] }
      end

      def option_override_values(opts)
        { backup: opts[:no_backup] ? '-' : opts[:backup] }
      end
    end
  end
end
