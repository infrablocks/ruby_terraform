require_relative 'base'

module RubyTerraform
  module Commands
    class Workspace < Base
      def command_line_commands(option_values)
        command_line_commands = ['workspace', option_values[:operation]]
        return command_line_commands unless option_values[:workspace] && option_values[:operation] != 'list'

        command_line_commands << option_values[:workspace]
      end

      def command_line_arguments(option_values)
        option_values[:directory]
      end

      def option_default_values(_opts)
        { directory: nil, operation: 'list', workspace: nil }
      end
    end
  end
end
