# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform providers+ command which prints out a tree of modules
    # in the referenced configuration annotated with their provider
    # requirements.
    #
    # This provides an overview of all of the provider requirements across all
    # referenced modules, as an aid to understanding why particular provider
    # plugins are needed and why particular versions are selected.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Plan} via {#execute}, the following
    # options are supported:
    #
    # * +:directory+: the path to a directory containing terraform
    #   configuration (deprecated in terraform 0.14, removed in terraform 0.15,
    #   use +:chdir+ instead).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # The {#execute} method accepts an optional second parameter which is a map
    # of invocation options. Currently, the only supported option is
    # +:environment+ which is a map of environment variables to expose during
    # invocation of the command.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Providers.new.execute
    #
    class Providers < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[providers]
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
