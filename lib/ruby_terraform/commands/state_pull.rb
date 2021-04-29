# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    # Wraps the +terraform state pull+ command which pulls the state from its
    # location, upgrades the local copy, and outputs it to stdout.
    #
    # This command "pulls" the current state and outputs it to stdout. As part
    # of this process, Terraform will upgrade the state format of the local copy
    # to the current version.
    #
    # The primary use of this is for state stored remotely. This command will
    # still work with local state but is less useful for this.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {StatePull} via {#execute}, the following
    # options are supported:
    #
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::StatePull.new.execute
    #
    class StatePull < Base
      include RubyTerraform::Options::Common

      # @!visibility private
      def subcommands
        %w[state pull]
      end
    end
  end
end
