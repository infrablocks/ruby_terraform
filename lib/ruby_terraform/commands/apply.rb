require_relative 'base'

module RubyTerraform
  module Commands
    class Apply < Base
      def sub_commands(_values)
        'apply'
      end

      def switches
        %w[-backup -lock -lock-timeout -input -auto-approve -no-color -state
           -target -var -var-file]
      end

      def arguments(values)
        values[:plan] || values[:directory]
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
