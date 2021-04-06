# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Commands
    class Workspace < Base
      def subcommands(parameters)
        commands = ['workspace', parameters[:operation]]
        if parameters[:workspace] && parameters[:operation] != 'list'
          commands << parameters[:workspace]
        else
          commands
        end
      end

      def arguments(parameters)
        [parameters[:directory]]
      end

      def parameter_defaults(_parameters)
        { directory: nil, operation: 'list', workspace: nil }
      end
    end
  end
end
