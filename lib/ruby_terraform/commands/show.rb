# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Commands
    class Show < Base
      def options
        %w[
          -json
          -module-depth
          -no-color
        ]
      end

      def subcommands(_parameters)
        %w[show]
      end

      def arguments(parameters)
        [parameters[:path] || parameters[:directory]]
      end
    end
  end
end
