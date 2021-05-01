# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform workspace list+ command which lists workspaces.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {WorkspaceList} via {#execute}, the
    # following options are supported:
    #
    # * +:directory+: the path to a directory containing terraform configuration
    #   (deprecated in terraform 0.14, removed in terraform 0.15, use +:chdir+
    #   instead).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::WorkspaceList.new.execute(
    #     directory: 'infra/networking')
    #
    class WorkspaceList < Base
      include RubyTerraform::Options::Global

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
