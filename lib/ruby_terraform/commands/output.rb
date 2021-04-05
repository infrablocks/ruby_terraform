require 'stringio'
require_relative 'base'

module RubyTerraform
  module Commands
    class Output < Base
      def initialize_command
        return if defined?(@stdout) && @stdout.respond_to?(:string)

        @stdout = StringIO.new
      end

      def switches
        %w[-json -raw -no-color -state -module]
      end

      def subcommands(_values)
        %w[output]
      end

      def arguments(values)
        [values[:name]]
      end

      def do_after(opts)
        result = stdout.string
        opts[:name] ? result.chomp : result
      end
    end
  end
end
