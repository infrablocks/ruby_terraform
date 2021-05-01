# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform taint+ command which marks a resource instance as not
    # fully functional.
    #
    # Terraform uses the term "tainted" to describe a resource instance which
    # may not be fully functional, either because its creation partially failed
    # or because you've manually marked it as such using this command.
    #
    # This will not modify your infrastructure directly, but subsequent
    # Terraform plans will include actions to destroy the remote object and
    # create a new object to replace it.
    #
    # You can remove the "taint" state from a resource instance using the
    # {Untaint} command.
    #
    # The address is in the usual resource address syntax, such as:
    #
    # * +aws_instance.foo+
    # * <tt>aws_instance.bar[1]</tt>
    # * +module.foo.module.bar.aws_instance.baz+
    #
    # Use your shell's quoting or escaping syntax to ensure that the address
    # will reach Terraform correctly, without any special interpretation.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Taint} via {#execute}, the following
    # options are supported:
    #
    # * +:address+: the module address or absolute resource address of the
    #   resource instance to taint; required.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:allow_missing+: if +true+, the command will succeed (i.e., will not
    #   throw an {RubyTerraform::Errors::ExecutionError}) even if the resource
    #   is missing; defaults to +false+.
    # * +:backup+: the path to backup the existing state file before modifying;
    #   defaults to the +:state_out+ path with +".backup"+ extension; set
    #   +:no_backup+ to +true+ to skip backups entirely.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+.
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+.
    # * +:no_backup+: when +true+, no backup file will be written; defaults to
    #   +false+.
    # * +:state+: the path to the state file from which to read state and in
    #   which to store state (unless +:state_out+ is specified); defaults to
    #   +"terraform.tfstate"+.
    # * +:state_out+: the path to write state to that is different than
    #   +:state+; this can be used to preserve the old state.
    # * +:ignore_remote_version+: whether or not to continue even if remote and
    #   local Terraform versions are incompatible; this may result in an
    #   unusable workspace, and should be used with extreme caution; defaults to
    #   +false+.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Taint.new.execute(
    #     address: 'aws_security_group.allow_all')
    #
    class Taint < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[taint]
      end

      # @!visibility private
      def options
        %w[
          -allow-missing
          -backup
          -lock
          -lock-timeout
          -state
          -state-out
          -ignore-remote-version
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:address]]
      end

      # @!visibility private
      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
