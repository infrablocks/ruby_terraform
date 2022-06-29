# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform validate+ command which checks whether a
    # configuration is valid.
    #
    # Validates the configuration files in a directory, referring only to the
    # configuration and not accessing any remote services such as remote state,
    # provider APIs, etc.
    #
    # Validate runs checks that verify whether a configuration is syntactically
    # valid and internally consistent, regardless of any provided variables or
    # existing state. It is thus primarily useful for general verification of
    # reusable modules, including correctness of attribute names and value
    # types.
    #
    # It is safe to run this command automatically, for example as a post-save
    # check in a text editor or as a test step for a re-usable module in a CI
    # system.
    #
    # Validation requires an initialized working directory with any referenced
    # plugins and modules installed. To initialize a working directory for
    # validation without accessing any configured remote backend, use the {Init}
    # command passing +:backend+ as +false+.
    #
    # To verify configuration in the context of a particular run (a particular
    # target workspace, input variable values, etc), use the {Plan} command
    # instead, which includes an implied validation check.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Validate} via {#execute}, the following
    # options are supported:
    #
    # * +:directory+: the path to a directory containing terraform configuration
    #   (deprecated in terraform 0.14, removed in terraform 0.15, use +:chdir+
    #   instead).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:json+: whether or not to produce output in a machine-readable JSON
    #   format, suitable for use in text editor integrations and other automated
    #   systems; always disables color; defaults to +false+.
    # * +:no_color+: whether or not the output from the command should be in
    #   color; defaults to +false+.
    #
    # The {#execute} method accepts an optional second parameter which is a map
    # of invocation options. Currently, the only supported option is
    # +:environment+ which is a map of environment variables to expose during
    # invocation of the command.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Validate.new.execute(
    #     directory: 'infra/networking')
    #
    class Validate < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[validate]
      end

      # @!visibility private
      def options
        %w[
          -json
          -no-color
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
