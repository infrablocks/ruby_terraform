require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Get < Base
      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            flags: %i[no_color update]
          }
        )
      end

      def command_line_commands(_option_values)
        'get'
      end

      def command_line_arguments(option_values)
        option_values[:directory]
      end
    end
  end
end
