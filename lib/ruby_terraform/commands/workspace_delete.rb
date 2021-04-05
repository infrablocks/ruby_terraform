# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class WorkspaceDelete < Base
      include RubyTerraform::Options::Common

      def subcommands(_parameters)
        %w[workspace delete]
      end

      def options
        %w[
          -force
          -lock
          -lock-timeout
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
