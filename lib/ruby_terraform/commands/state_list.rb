# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform state list+ command which lists resources in the
    # Terraform state.
    #
    # This command lists resource instances in the Terraform state. The address
    # option can be used to filter the instances by resource or module. If no
    # pattern is given, all resource instances are listed.
    #
    # The addresses must either be module addresses or absolute resource
    # addresses, such as:
    #
    # * +aws_instance.example+
    # * +module.example+
    # * +module.example.module.child+
    # * +module.example.aws_instance.example+
    #
    # An {RubyTerraform::Errors::ExecutionError} will be raised if any of the
    # resources or modules given as filter addresses do not exist in the state.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {StateList} via {#execute}, the following
    # options are supported:
    #
    # * +:address+: the module address or absolute resource address to filter
    #   by.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:state+: the path to a Terraform state file to use to look up
    #   Terraform-managed resources; by default, Terraform will consult the
    #   state of the currently-selected workspace.
    # * +:id+: when provided, filters the results to include only instances
    #   whose resource types have an attribute named "id" whose value equals the
    #   given id string.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::StateList.new.execute
    #
    class StateList < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[state list]
      end

      # @!visibility private
      def options
        %w[
          -state
          -id
        ] + super
      end

      # @!visibility private
      # @todo Add addresses arg and flatten
      def arguments(parameters)
        [parameters[:address]]
      end
    end
  end
end
