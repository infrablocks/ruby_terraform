# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Commands
    class Get < Base
      def options
        %w[
          -no-color
          -update
        ]
      end

      def subcommands(_parameters)
        %w[get]
      end

      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
