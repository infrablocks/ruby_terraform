# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class WorkspaceList < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[workspace list]
      end

      def arguments(parameters)
        [parameters[:directory]]
      end

      def parameter_defaults(_parameters)
        { directory: nil }
      end
    end
  end
end
