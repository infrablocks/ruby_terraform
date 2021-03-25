require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Init < Base
      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            standard: %i[backend_config from_module plugin_dir],
            boolean: %i[backend force_copy get],
            flags: %i[no_color]
          }
        )
      end

      def command_line_commands(_option_values)
        'init'
      end

      def command_line_arguments(option_values)
        option_values[:path]
      end

      def option_default_values(_opts)
        { backend_config: {} }
      end
    end
  end
end
