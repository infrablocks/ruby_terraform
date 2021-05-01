# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform get+ command which downloads and installs modules
    # needed for the given configuration.
    #
    # This recursively downloads all modules needed, such as modules imported by
    # the root and so on. If a module is already downloaded, it will not be
    # redownloaded or checked for updates unless +:update+ is +true+.
    #
    # Module installation also happens automatically by default as part of
    # the {Init} command, so you should rarely need to run this
    # command separately.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Get} via {#execute}, the following options
    # are supported:
    #
    # * +:directory+: the path to a directory containing terraform
    #   configuration.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:update+: if +true+, checks already-downloaded modules for available
    #   updates and installs the newest versions available; defaults to +false+.
    # * +:no_color+: whether or not the output from the command should be in
    #   color; defaults to +false+.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Get.new.execute(
    #     directory: 'infra/networking')
    class Get < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[get]
      end

      # @!visibility private
      def options
        %w[
          -no-color
          -update
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
