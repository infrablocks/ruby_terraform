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
    # * +:name+: the name of the workspace to delete; required.
    # * +:directory+: the path to a directory containing terraform configuration
    #   (deprecated in terraform 0.14, removed in terraform 0.15, use +:chdir+
    #   instead).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:force+: whether or not to remove a non-empty workspace; defaults to
    #   +false+.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+.
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+.
    #
    # The {#execute} method accepts an optional second parameter which is a map
    # of invocation options. Currently, the only supported option is
    # +:environment+ which is a map of environment variables to expose during
    # invocation of the command.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::WorkspaceDelete.new.execute(
    #     name: 'example')
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
      def arguments(parameters)
        [parameters[:name], parameters[:directory]]
      end
    end
  end
end
