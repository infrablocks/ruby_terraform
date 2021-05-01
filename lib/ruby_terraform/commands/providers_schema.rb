# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform providers schema+ command which prints out a json
    # representation of the schemas for all providers used in the current
    # configuration.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {ProvidersSchema} via {#execute}, the
    # following options are supported:
    #
    # * +:directory+: the path to the directory containing the configuration to
    #   show provider schemas for.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::ProvidersSchema.new.execute(
    #     directory: 'infra/networking')
    #
    class ProvidersSchema < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[providers schema]
      end

      # @!visibility private
      def options
        %w[-json] + super
      end

      # @!visibility private
      def parameter_overrides(_parameters)
        # Terraform 0.15 - at this time, the -json flag is a required option.
        { json: true }
      end
    end
  end
end
