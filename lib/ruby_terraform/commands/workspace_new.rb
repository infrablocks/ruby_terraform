# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class WorkspaceNew < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[workspace new]
      end

      def options
        %w[
          -lock
          -lock-timeout
          -state
        ] + super
      end

      def arguments(parameters)
        [parameters[:workspace], parameters[:directory]]
      end

      def parameter_defaults(_parameters)
        { directory: nil }
      end
    end
  end
end
