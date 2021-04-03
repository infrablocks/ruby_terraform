require_relative 'base'

module RubyTerraform
  module Commands
    class RemoteConfig < Base
      def switches
        %w[-backend -backend-config -no-color]
      end

      def sub_commands(_values)
        %w[remote config]
      end

      def option_default_values(_opts)
        { backend_config: {} }
      end
    end
  end
end
