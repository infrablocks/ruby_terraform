require 'stringio'
require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Output < Base
      def initialize_command
        @stdout = StringIO.new unless defined?(@stdout) && @stdout.respond_to?(:string)
      end

      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            standard: %i[module state],
            flags: %i[json no_color]
          }
        )
      end

      def command_line_commands(_option_values)
        'output'
      end

      def command_line_arguments(option_values)
        option_values[:name]
      end

      def do_after(opts)
        result = stdout.string
        opts[:name] ? result.chomp : result
      end
    end
  end
end
