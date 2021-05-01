# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform state replace-provider+ command which replaces
    # provider for resources in the Terraform state.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {StateReplaceProvider} via {#execute}, the
    # following options are supported:
    #
    # * +:from+: the fully qualified name of the provider to be replaced;
    #   required.
    # * +:to+: the fully qualified name of the provider to replace with;
    #   required.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:auto_approve+: if +true+, skips interactive approval; defaults to
    #   +false+.
    # * +:backup+: the path where Terraform should write the backup for the
    # 	state file; this can't be disabled; if not set, Terraform will write it
    # 	to the same path as the state file with a ".backup" extension.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+.
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+.
    # * +:state+: the path to the state file to update; defaults to the current
    #   workspace state.
    # * +:ignore_remote_version+: whether or not to continue even if remote and
    #   local Terraform versions are incompatible; this may result in an
    #   unusable workspace, and should be used with extreme caution; defaults to
    #   +false+.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::StateReplaceProvider.new.execute(
    #     from: 'hashicorp/aws',
    #     to: 'registry.acme.corp/acme/aws')
    #
    class StateReplaceProvider < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[state replace-provider]
      end

      # @!visibility private
      def options
        %w[
          -auto-approve
          -backup
          -lock
          -lock-timeout
          -state
          -ignore-remote-version
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:from], parameters[:to]]
      end

      # @!visibility private
      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
