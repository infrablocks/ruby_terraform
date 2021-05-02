# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform workspace select+ command which selects a workspace.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {WorkspaceSelect} via {#execute}, the
    # following options are supported:
    #
    # * +:name+: the name of the workspace to select; required.
    # * +:directory+: the path to a directory containing terraform configuration
    #   (deprecated in terraform 0.14, removed in terraform 0.15, use +:chdir+
    #   instead).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # @example BasicInvocation
    #   RubyTerraform::Commands::WorkspaceSelect.new.execute(
    #     name: 'example')
    #
    class WorkspaceSelect < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[workspace select]
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:name], parameters[:directory]]
      end
    end
  end
end
