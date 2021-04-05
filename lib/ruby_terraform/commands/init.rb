require_relative 'base'

module RubyTerraform
  module Commands
    class Init < Base
      def switches
        %w[
          -backend
          -backend-config
          -force-copy
          -from-module
          -get
          -no-color
          -plugin-dir
        ]
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
