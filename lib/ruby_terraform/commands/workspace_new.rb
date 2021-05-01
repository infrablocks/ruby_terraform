# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform workspace new+ command which creates a new workspace.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {WorkspaceNew} via {#execute}, the
    # following options are supported:
    #
    # * +:workspace+: the name of the workspace to create; required.
    # * +:directory+: the directory containing terraform configuration
    #   (deprecated).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+.
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+.
    # * +:state+: the path to a state file to copy into the new workspace.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::WorkspaceNew.new.execute(
    #     workspace: 'example')
    #
    class WorkspaceNew < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[workspace new]
      end

      # @!visibility private
      def options
        %w[
          -lock
          -lock-timeout
          -state
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:workspace], parameters[:directory]]
      end
    end
  end
end
