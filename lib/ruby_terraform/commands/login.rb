# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform login+ command which retrieves an authentication
    # token for the given hostname, if it supports automatic login, and saves it
    # in a credentials file in your home directory.
    #
    # If no hostname is provided, the default hostname is app.terraform.io, to
    # log in to Terraform Cloud.
    #
    # If not overridden by credentials helper settings in the CLI configuration,
    # the credentials will be written to the following local file:
    #   ~/.terraform.d/credentials.tfrc.json
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Login} via {#execute}, the following
    # options are supported:
    #
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Login.new.execute
    #
    class Login < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[login]
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:hostname]]
      end
    end
  end
end
