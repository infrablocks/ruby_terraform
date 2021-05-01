# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform workspace delete+ command which deletes a workspace.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {WorkspaceDelete} via {#execute}, the
    # following options are supported:
    #
    # * +:workspace+: the name of the workspace to delete; required.
    # * +:directory+: the path to a directory containing terraform configuration
    #   (deprecated).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:force+: whether or not to remove a non-empty workspace; defaults to
    #   +false+.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+.
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::WorkspaceDelete.new.execute(
    #     workspace: 'example')
    #
    class WorkspaceDelete < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[workspace delete]
      end

      # @!visibility private
      def options
        %w[
          -force
          -lock
          -lock-timeout
        ] + super
      end

      # @!visibility private
      # @todo Rename workspace to name.
      def arguments(parameters)
        [parameters[:workspace], parameters[:directory]]
      end
    end
  end
end
