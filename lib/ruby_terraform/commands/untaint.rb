# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform untaint+ command which removes the 'tainted' state
    # from a resource instance.
    #
    # Terraform uses the term "tainted" to describe a resource instance
    # which may not be fully functional, either because its creation partially
    # failed or because you've manually marked it as such using the {Taint}
    # command.
    #
    # This command removes that state from a resource instance, causing
    # Terraform to see it as fully-functional and not in need of replacement.
    #
    # This will not modify your infrastructure directly. It only avoids
    # Terraform planning to replace a tainted instance in a future operation.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Untaint} via {#execute}, the following
    # options are supported:
    #
    # * +:name+: the name of the resource instance to untaint; required.
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
    # * +:no_color+: whether or not the output from the command should be in
    #   color; defaults to +false+.
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
    #   RubyTerraform::Commands::Untaint.new.execute(
    #     name: 'aws_security_group.allow_all')
    #
    class Untaint < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[untaint]
      end

      # @!visibility private
      def options
        %w[
          -allow-missing
          -backup
          -lock
          -lock-timeout
          -no-color
          -state
          -state-out
          -ignore-remote-version
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:name]]
      end

      # @!visibility private
      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
