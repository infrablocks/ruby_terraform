# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform state show+ command which shows the attributes of a
    # resource in the Terraform state.
    #
    # This command shows the attributes of a single resource in the Terraform
    # state. The +:address+ argument must be used to specify a single resource.
    # You can view the list of available resources with {StateList}.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {StateShow} via {#execute}, the following
    # options are supported:
    #
    # * +:address+: the module address or absolute resource address of the
    #   resource instance to show; required.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # The {#execute} method accepts an optional second parameter which is a map
    # of invocation options. Currently, the only supported option is
    # +:environment+ which is a map of environment variables to expose during
    # invocation of the command.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::StateShow.new.execute(
    #     address: 'packet_device.worker')
    #
    class StateShow < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[state show]
      end

      # @!visibility private
      def options
        %w[-state] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:address]]
      end
    end
  end
end
