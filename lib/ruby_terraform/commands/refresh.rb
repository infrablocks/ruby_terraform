# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Commands
    class Refresh < Base
      def options
        %w[
          -input
          -no-color
          -state
          -target
          -var
          -var-file
        ]
      end

      def subcommands(_parameters)
        %w[refresh]
      end

      def arguments(parameters)
        [parameters[:directory]]
      end

      def parameter_defaults(_parameters)
        { vars: {}, var_files: [], targets: [] }
      end
    end
  end
end
