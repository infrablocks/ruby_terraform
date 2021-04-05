require_relative 'base'

module RubyTerraform
  module Commands
    class Refresh < Base
      def switches
        %w[-input -no-color -state -target -var -var-file]
      end

      def subcommands(_values)
        %w[refresh]
      end

      def arguments(values)
        [values[:directory]]
      end

      def option_default_values(_opts)
        { vars: {}, var_files: [], targets: [] }
      end
    end
  end
end
