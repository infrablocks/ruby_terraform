# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Commands
    class Init < Base
      def options
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

      def subcommands(_parameters)
        %w[init]
      end

      def arguments(parameters)
        [parameters[:path]]
      end

      def parameter_defaults(_parameters)
        { backend_config: {} }
      end
    end
  end
end
