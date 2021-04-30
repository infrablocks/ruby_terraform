# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    # Wraps the +terraform workspace list+ command which lists workspaces.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {WorkspaceList} via {#execute}, the
    # following options are supported:
    #
    # * +:directory+: the directory containing terraform configuration
    #   (deprecated).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::WorkspaceList.new.execute(
    #     directory: 'infra/networking')
    #
    class WorkspaceList < Base
      include RubyTerraform::Options::Common

      # @!visibility private
      def subcommands
        %w[workspace list]
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
