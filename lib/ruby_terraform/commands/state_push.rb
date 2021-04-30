# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    # Wraps the +terraform state push+ command which updates remote state from
    # a local state file.
    #
    # This command "pushes" a local state and overwrites remote state with a
    # local state file. The command will protect you against writing
    # an older serial or a different state file lineage unless you pass +true+
    # for the +:force+ option.
    #
    # This command works with local state (it will overwrite the local state),
    # but is less useful for this use case.
    #
    # If +:path+ is +"-"+, then this command will read the state to push from
    # stdin. Data from stdin is not streamed to the backend: it is loaded
    # completely (until pipe close), verified, and then pushed.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {StatePush} via {#execute}, the following
    # options are supported:
    #
    # * +:path+: the path to the state file to push; when passed +"-"+ will
    #   read state from standard input.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:ignore_remote_version+: whether or not to continue even if remote and
    #   local Terraform versions are incompatible; this may result in an
    #   unusable workspace, and should be used with extreme caution; defaults to
    #   +false+.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::StatePush.new.execute(
    #     path: 'some/statefile.tfstate')
    #
    class StatePush < Base
      include RubyTerraform::Options::Common

      # @!visibility private
      def subcommands
        %w[state push]
      end

      # @!visibility private
      # @todo Add force, lock and lock_timeout options.
      def options
        %w[-ignore-remote-version] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:path]]
      end
    end
  end
end
