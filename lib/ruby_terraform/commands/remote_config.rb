require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class RemoteConfig < Base
      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            standard: %i[backend backend_config],
            flags: %i[no_color]
          }
        )
      end

      def command_line_commands(_option_values)
        %w[remote config]
      end

      def option_default_values(_opts)
        { backend_config: {} }
      end
    end
  end
end
