require_relative 'base'

module RubyTerraform
  module Commands
    class Plan < Base
      def switches
        %w[-destroy -input -no-color -out -state -target -var -var-file]
      end

      def sub_commands(_values)
        'plan'
      end

      def option_default_values(_opts)
        { vars: {}, var_files: [], targets: [] }
      end

      def arguments(values)
        values[:directory]
      end
    end
  end
end
