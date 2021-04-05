require_relative 'base'

module RubyTerraform
  module Commands
    class RemoteConfig < Base
      def options
        %w[
          -backend
          -backend-config
          -no-color
        ]
      end

      def subcommands(_parameters)
        %w[remote config]
      end

      def parameter_defaults(_parameters)
        { backend_config: {} }
      end
    end
  end
end
