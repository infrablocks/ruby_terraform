require_relative 'base'

module RubyTerraform
  module Commands
    class Workspace < Base
      def sub_commands(values)
        commands = ['workspace', values[:operation]]
        if values[:workspace] && values[:operation] != 'list'
          commands << values[:workspace]
        else
          commands
        end
      end

      def arguments(values)
        values[:directory]
      end

      def option_default_values(_opts)
        { directory: nil, operation: 'list', workspace: nil }
      end
    end
  end
end
