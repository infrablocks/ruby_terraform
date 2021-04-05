require_relative 'base'

module RubyTerraform
  module Commands
    class Validate < Base
      def switches
        %w[-json -no-color -var -var-file -state -check-variables] + super
      end

      def sub_commands(_values)
        %w[validate]
      end

      def arguments(values)
        [values[:directory]]
      end

      def option_default_values(_opts)
        { vars: {}, var_files: [] }
      end
    end
  end
end
