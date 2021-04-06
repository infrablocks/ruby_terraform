# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Commands
    class Format < Base
      def options
        %w[
          -check
          -diff
          -list
          -no-color
          -recursive
          -write
        ]
      end

      def subcommands(_parameters)
        %w[fmt]
      end

      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
