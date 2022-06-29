# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform logout+ command which removes locally-stored
    # credentials for specified hostname.
    #
    # Note: the API token is only removed from local storage, not destroyed on
    # the remote server, so it will remain valid until manually revoked.
    #
    # If no hostname is provided, the default hostname is app.terraform.io.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Logout} via {#execute}, the following
    # options are supported:
    #
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    #
    # The {#execute} method accepts an optional second parameter which is a map
    # of invocation options. Currently, the only supported option is
    # +:environment+ which is a map of environment variables to expose during
    # invocation of the command.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Logout.new.execute
    #
    class Logout < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[logout]
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:hostname]]
      end
    end
  end
end
