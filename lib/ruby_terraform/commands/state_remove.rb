# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    # Wraps the +terraform state rm+ command which removes one or more items
    # from the Terraform state, causing Terraform to "forget" those items
    #  without first destroying them in the remote system.
    #
    # This command removes one or more resource instances from the Terraform
    # state based on the addresses given. You can view and list the available
    # instances with {StateList}.
    #
    # If you give the address of an entire module then all of the instances in
    # that module and any of its child modules will be removed from the state.
    #
    # If you give the address of a resource that has "count" or "for_each" set,
    # all of the instances of that resource will be removed from the state.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {StateRemove} via {#execute}, the following
    # options are supported:
    #
    # * +:address+: the module address or absolute resource address of the
    #   resource instance to remove; required.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:backup+: the path where Terraform should write the backup state.
    # * +:state+: the path to the state file to update; defaults to the current
    #   workspace state.
    # * +:ignore_remote_version+: whether or not to continue even if remote and
    #   local Terraform versions are incompatible; this may result in an
    #   unusable workspace, and should be used with extreme caution; defaults to
    #   +false+.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::StateRemove.new.execute(
    #     address: 'packet_device.worker')
    #
    class StateRemove < Base
      include RubyTerraform::Options::Common

      # @!visibility private
      def subcommands
        %w[state rm]
      end

      # @!visibility private
      # @todo Add dry_run, lock and lock_timeout options.
      def options
        %w[
          -backup
          -state
          -ignore-remote-version
        ] + super
      end

      # @!visibility private
      # @todo Add addresses arg and flatten
      def arguments(parameters)
        [parameters[:address]]
      end

      # @!visibility private
      # @todo Remove no_backup since backup can't be disabled for this command.
      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
