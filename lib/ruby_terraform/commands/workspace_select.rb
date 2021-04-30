# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    # Wraps the +terraform workspace select+ command which selects a workspace.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {WorkspaceSelect} via {#execute}, the
    # following options are supported:
    #
    # * +:workspace+: the name of the workspace to select; required.
    # * +:directory+: the directory containing terraform configuration
    #   (deprecated).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # @example BasicInvocation
    #   RubyTerraform::Commands::WorkspaceSelect.new.execute(
    #     workspace: 'example')
    #
    class WorkspaceSelect < Base
      include RubyTerraform::Options::Common

      # @!visibility private
      def subcommands
        %w[workspace select]
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:workspace], parameters[:directory]]
      end
    end
  end
end
