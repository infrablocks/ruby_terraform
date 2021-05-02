# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform providers lock+ command which writes out dependency
    # locks for the configured providers.
    #
    # Normally the dependency lock file (.terraform.lock.hcl) is updated
    # automatically by "terraform init", but the information available to the
    # normal provider installer can be constrained when you're installing
    # providers from filesystem or network mirrors, and so the generated lock
    # file can end up incomplete.
    #
    # The "providers lock" subcommand addresses that by updating the lock file
    # based on the official packages available in the origin registry, ignoring
    # the currently-configured installation strategy.
    #
    # After this command succeeds, the lock file will contain suitable checksums
    # to allow installation of the providers needed by the current configuration
    # on all of the selected platforms.
    #
    # By default this command updates the lock file for every provider declared
    # in the configuration. You can override that behavior by providing one or
    # more provider source addresses on the command line.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {ProvidersLock} via {#execute}, the
    # following options are supported:
    #
    # * +:provider+: the provider source address for which the lock file
    #   should be updated; if both +:provider+ and +:providers+ are provided,
    #   all providers will be passed to Terraform.
    # * +:providers+: an array of provider source addresses for which the lock
    #   file should be updated; if both +:provider+ and +:providers+ are
    #   provided, all providers will be passed to Terraform.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:fs_mirror+: if provided, consults the given filesystem mirror
    #   directory instead of the origin registry for each of the given
    #   providers; this would be necessary to generate lock file entries for
    #   a provider that is available only via a mirror, and not published in an
    #   upstream registry; in this case, the set of valid checksums will be
    #   limited only to what Terraform can learn from the data in the mirror
    #   directory.
    # * +:net_mirror+: if provided, consults the given network mirror (given as
    #   a base URL) instead of the origin registry for each of the given
    #   providers; this would be necessary to generate lock file entries for a
    #   provider that is available only via a mirror, and not published in an
    #   upstream registry; in this case, the set of valid checksums will be
    #   limited only to what Terraform can learn from the data in the mirror
    #   indices.
    # * +:platform+: the target platform to request package checksums for; by
    #   default Terraform will request package checksums suitable only for the
    #   platform where you run this command; target names consist of an
    #   operating system and a CPU architecture; for example, "linux_amd64"
    #   selects the Linux operating system running on an AMD64 or x86_64 CPU;
    #   each provider is available only for a limited set of target platforms;
    #   if both +:platform+ and +:platforms+ are provided, all platforms will be
    #   passed to Terraform.
    # * +:platforms+: an array of target platforms to request package checksums
    #   for; see +:platform+ for more details; if both +:platform+ and
    #   +:platforms+ are provided, all platforms will be passed to Terraform.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::ProvidersLock.new.execute(
    #     fs_mirror: "/usr/local/terraform/providers",
    #     platforms: ["windows_amd64", "darwin_amd64", "linux_amd64"],
    #     provider: "tf.example.com/ourcompany/ourplatform")
    #
    class ProvidersLock < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[providers lock]
      end

      # @!visibility private
      def options
        %w[
          -fs-mirror
          -net-mirror
          -platform
        ] + super
      end

      # @!visibility private
      def arguments(parameters)
        [parameters[:provider], parameters[:providers]]
      end
    end
  end
end
