# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

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
    #   resource instance to remove; required unless +:addresses+ is supplied;
    #   if both +:address+ and +:addresses+ are provided, all addresses will be
    #   passed to Terraform.
    # * +:addresses+: an array of module addresses or absolute resource
    #   addresses of the resource instances to remove; required unless
    #   +:address+ is supplied; if both +:address+ and +:addresses+ are
    #   provided, all addresses will be passed to Terraform.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:dry+run+: when +true+, prints out what would've been removed but
    #   doesn't actually remove anything; defaults to +false+.
    # * +:backup+: the path where Terraform should write the backup state.
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
    #   RubyTerraform::Commands::StateRemove.new.execute(
    #     address: 'packet_device.worker')
    #
    class StateRemove < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[state rm]
      end

      # @!visibility private
      def options
        %w[
          -dry-run
          -backup
          -lock
          -lock-timeout
          -state
          -ignore-remote-version
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:address], parameters[:addresses]]
      end
    end
  end
end
