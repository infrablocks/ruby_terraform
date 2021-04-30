# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    # Wraps the +terraform workspace show+ command which shows the name of the
    # current workspace.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {WorkspaceSelect} via {#execute}, the
    # following options are supported:
    #
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::WorkspaceShow.new.execute
    #
    class WorkspaceShow < Base
      include RubyTerraform::Options::Common

      # @!visibility private
      def subcommands
        %w[workspace show]
      end
    end
  end
end
