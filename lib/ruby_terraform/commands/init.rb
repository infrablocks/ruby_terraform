# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Init < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[init]
      end

      def options # rubocop:disable Metrics/MethodLength
        %w[
          -backend
          -backend-config
          -force-copy
          -from-module
          -get
          -get-plugins
          -input
          -lock
          -lock-timeout
          -no-color
          -plugin-dir
          -reconfigure
          -upgrade
          -verify-plugins
        ] + super
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
