# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform providers mirror+ command which saves local copies of
    # all required provider plugins.
    #
    # Populates a local directory with copies of the provider plugins needed for
    # the current configuration, so that the directory can be used either
    # directly as a filesystem mirror or as the basis for a network mirror and
    # thus obtain those providers without access to their origin registries in
    # future.
    #
    # The mirror directory will contain JSON index files that can be published
    # along with the mirrored packages on a static HTTP file server to produce a
    # network mirror. Those index files will be ignored if the directory is used
    # instead as a local filesystem mirror.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {ProvidersMirror} via {#execute}, the
    # following options are supported:
    #
    # * +:directory+: the directory to populate with the mirrored provider
    #   plugins.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:platform+: the target platform to build a mirror for; by default
    #   Terraform will obtain plugin packages suitable for the platform where
    #   you run this command; target names consist of an operating system and a
    #   CPU architecture; for example, "linux_amd64" selects the Linux operating
    #   system running on an AMD64 or x86_64 CPU; each provider is available
    #   only for a limited set of target platforms; if both +:platform+ and
    #   +:platforms+ are provided, all platforms will be passed to Terraform.
    # * +:platforms+: an array of target platforms to build a mirror for for;
    #   see +:platform+ for more details; if both +:platform+ and +:platforms+
    #   are provided, all platforms will be passed to Terraform.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::ProvidersMirror.new.execute(
    #     directory: './plugins',
    #     platforms: ["windows_amd64", "darwin_amd64", "linux_amd64"])
    #
    class ProvidersMirror < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[providers mirror]
      end

      # @!visibility private
      def options
        %w[-platform] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
