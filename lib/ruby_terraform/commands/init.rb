require_relative 'base'

module RubyTerraform
  module Commands
    class Init < Base
      def switches
        %w[-backend -backend-config -from-module -get -no-color -plugin-dir
           -force-copy]
      end

      def subcommands(_values)
        %w[init]
      end

      def arguments(values)
        [values[:path]]
      end

      def option_default_values(_opts)
        { backend_config: {} }
      end
    end
  end
end
