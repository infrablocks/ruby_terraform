require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Validate < Base
      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            flags: %i[json no_color]
          }
        )
      end

      def command_line_commands(_option_values)
        'validate'
      end

      def command_line_arguments(option_values)
        option_values[:directory]
      end

      def option_default_values(_opts)
        { vars: {}, var_files: [] }
      end
    end
  end
end
