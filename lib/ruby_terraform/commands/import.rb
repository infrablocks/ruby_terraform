# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform import+ command which imports existing infrastructure
    # into your terraform state.
    #
    # This will find and import the specified resource into your terraform
    # state, allowing existing infrastructure to come under terraform
    # management without having to be initially created by terraform.
    #
    # The +:address+ specified is the address to import the resource to. Please
    # see the documentation online for resource addresses. The +:id+ is a
    # resource-specific ID to identify that resource being imported. Please
    # reference the documentation for the resource type you're importing to
    # determine the ID syntax to use. It typically matches directly to the ID
    # that the provider uses.
    #
    # The current implementation of terraform import can only import resources
    # into the state. It does not generate configuration. A future version of
    # terraform will also generate configuration.
    #
    # Because of this, prior to running terraform import it is necessary to
    # write a resource configuration block for the resource manually, to which
    # the imported object will be attached.
    #
    # This command will not modify your infrastructure, but it will make network
    # requests to inspect parts of your infrastructure relevant to the resource
    # being imported.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Import} via {#execute}, the following
    # options are supported:
    #
    # * +:directory+: the path to a directory of terraform configuration files
    #   to use to configure the provider; defaults to the current directory; if
    #   no config files are present, they must be provided via the input prompts
    #   or env vars.
    # * +:address+: the address to import the resource to; required.
    # * +:id+: the resource-specific ID identifying the resource being imported;
    #   required.
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:backup+: (legacy) the path to backup the existing state file before
    #   modifying; defaults to the +:state_out+ path with +".backup"+ extension;
    #   set +:no_backup+ to +true+ to skip backups entirely.
    # * +:input+: when +false+, will not ask for input for variables not
    #   directly set; defaults to +true+.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+.
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+.
    # * +:no_backup+: (legacy) when +true+, no backup file will be written;
    #   defaults to +false+.
    # * +:no_color+: whether or not the output from the command should be in
    #   color; defaults to +false+.
    # * +:parallelism+: the number of parallel resource operations; defaults to
    #   +10+.
    # * +:provider+: (deprecated) the provider configuration to use when
    #   importing the object; by default, terraform uses the provider specified
    #   in the configuration for the target resource, and that is the best
    #   behavior in most cases.
    # * +:state+: (legacy) the path to the state file from which to read state
    #   and in which to store state (unless +:state_out+ is specified); defaults
    #   to +"terraform.tfstate"+.
    # * +:state_out+: (legacy) the path to write state to that is different than
    #   +:state+; this can be used to preserve the old state.
    # * +:vars+: a map of variables to be passed to the terraform configuration.
    # * +:var_file+: the path to a terraform var file; if both +:var_file+ and
    #   +:var_files+ are provided, all var files will be passed to terraform.
    # * +:var_files+: an array of paths to terraform var files; if both
    #   +:var_file+ and +:var_files+ are provided, all var files will be passed
    #   to terraform.
    # * +:ignore_remote_version+: If +true+, when using the enhanced remote
    #   backend with Terraform Cloud, continue even if remote and local
    #   Terraform versions differ; this may result in an unusable Terraform
    #   Cloud workspace, and should be used with extreme caution; defaults to
    #   +false+.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Import.new.execute(
    #     directory: 'infra/networking',
    #     address: 'a.resource.address',
    #     id: 'a-resource-id',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    class Import < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[import]
      end

      # rubocop:disable Metrics/MethodLength

      # @!visibility private
      # @todo Add allow_missing_config option.
      def options
        %w[
          -config
          -backup
          -input
          -lock
          -lock-timeout
          -no-color
          -parallelism
          -provider
          -state
          -state-out
          -var
          -var-file
          -ignore-remote-version
        ] + super
      end

      # rubocop:enable Metrics/MethodLength

      # @!visibility private
      def arguments(parameters)
        [parameters[:address], parameters[:id]]
      end

      # @!visibility private
      def parameter_defaults(_parameters)
        { vars: {}, var_files: [] }
      end

      # @!visibility private
      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
