# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Commands
    class RemoteConfig < Base
      def subcommands
        %w[remote config]
      end

      def options
        %w[
          -backend
          -backend-config
          -no-color
        ]
      end

      def parameter_defaults(_parameters)
        { backend_config: {} }
      end
    end
  end
end
