require 'stringio'
require_relative 'base'

module RubyTerraform
  module Commands
    class Output < Base
      def initialize_command
        return if defined?(@stdout) && @stdout.respond_to?(:string)

        @stdout = StringIO.new
      end

      def options
        %w[
          -json
          -module
          -no-color
          -raw
          -state
        ]
      end

      def subcommands(_parameters)
        %w[output]
      end

      def arguments(parameters)
        [parameters[:name]]
      end

      def do_after(parameters)
        result = stdout.string
        parameters[:name] ? result.chomp : result
      end
    end
  end
end
