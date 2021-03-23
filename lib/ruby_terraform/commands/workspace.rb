require_relative 'base'

module RubyTerraform
  module Commands
    class Workspace < Base
      def configure_command(builder, opts)
        directory = opts[:directory] || nil
        operation = opts[:operation] || 'list'
        workspace = opts[:workspace] || nil

        builder = builder
            .with_subcommand('workspace')
            .with_subcommand(operation)

        builder = builder.with_subcommand(workspace) if
            workspace && operation != 'list'
        builder = builder.with_argument(directory)

        builder
      end
    end
  end
end