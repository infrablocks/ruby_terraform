# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform state mv+ command which moves an item in the state.
    #
    # This command will move an item matched by the address given to the
    # destination address. This command can also move to a destination address
    # in a completely different state file.
    #
    # This can be used for simple resource renaming, moving items to and from
    # a module, moving entire modules, and more. And because this command can
    # also move data to a completely new state, it can also be used for
    # refactoring one configuration into multiple separately managed Terraform
    # configurations.
    #
    # This command will output a backup copy of the state prior to saving any
    # changes. The backup cannot be disabled. Due to the destructive nature
    # of this command, backups are required.
    #
    # If you're moving an item to a different state file, a backup will be
    # created for each state file.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {StateMove} via {#execute}, the following
    # options are supported:
    #
    # * +:source+: the source address of the item to move; required.
    # * +:destination+: the destination address to move the item to; required.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:dry_run+: when +true+, prints out what would've been moved but doesn't
    #   actually move anything; defaults to +false+.
    # * +:backup+: the path where Terraform should write the backup for the
    #   original state; this can't be disabled; if not set, Terraform will write
    #   it to the same path as the state file with a +".backup"+ extension.
    # * +:backup_out+: the path where Terraform should write the backup for the
    #   destination state; this can't be disabled; if not set, Terraform will
    #   write it to the same path as the destination state file with a
    #   +".backup"+ extension; this only needs to be specified if +:state_out+
    #   is set to a different path than +:state+.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+.
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+.
    # * +:state+: the path to the source state file; defaults to the configured
    #   backend, or +"terraform.tfstate"+.
    # * +:state_out+: the path to the destination state file to write to; if
    #   this isn't specified, the source state file will be used; this can be a
    #   new or existing path.
    # * +:ignore_remote_version+: whether or not to continue even if remote and
    #   local Terraform versions are incompatible; this may result in an
    #   unusable workspace, and should be used with extreme caution; defaults to
    #   +false+.
    #
    # The {#execute} method accepts an optional second parameter which is a map
    # of invocation options. Currently, the only supported option is
    # +:environment+ which is a map of environment variables to expose during
    # invocation of the command.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::StateMove.new.execute(
    #     source: 'packet_device.worker',
    #     destination: 'packet_device.helper')
    #
    class StateMove < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[state mv]
      end

      # @!visibility private
      def options
        %w[
          -dry-run
          -backup
          -backup-out
          -lock
          -lock-timeout
          -state
          -state-out
          -ignore-remote-version
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:source], parameters[:destination]]
      end
    end
  end
end
