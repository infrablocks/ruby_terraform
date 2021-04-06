# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class WorkspaceSelect < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[workspace select]
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
