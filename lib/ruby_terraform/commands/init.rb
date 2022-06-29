# frozen_string_literal: true

require_relative 'base'
require_relative '../options/global'

module RubyTerraform
  module Commands
    # Wraps the +terraform init+ command which initializes a new or existing
    # Terraform working directory by creating initial files, loading any remote
    # state, downloading modules, etc.
    #
    # This is the first command that should be run for any new or existing
    # Terraform configuration per machine. This sets up all the local data
    # necessary to run Terraform that is typically not committed to version
    # control.
    #
    # This command is always safe to run multiple times. Though subsequent runs
    # may give errors, this command will never delete your configuration or
    # state. Even so, if you have important information, please back it up prior
    # to running this command, just in case.
    #
    # For options accepted on construction, see {#initialize}.
    #
    # When executing an instance of {Init} via {#execute}, the following
    # options are supported:
    #
    # * +:path+: the path to initialize; defaults to the current directory
    #   (deprecated in terraform 0.14, removed in terraform 0.15, use +:chdir+
    #   instead).
    # * +:chdir+: the path of a working directory to switch to before executing
    #   the given subcommand.
    # * +:backend+: whether or not to configure the backend for this
    #   configuration; defaults to +true+.
    # * +:backend_config+: a map of backend specific configuration parameters.
    # * +:force_copy+: if +true+, suppresses prompts about copying state data;
    #   this is equivalent to providing a "yes" to all confirmation prompts;
    #   defaults to +false+.
    # * +:from_module+: copies the contents of the given module into the target
    #   directory before initialization.
    # * +:get+: whether or not to download any modules for this configuration;
    #   defaults to +true+.
    # * +:get_plugins+: whether or not to install plugins for this
    #   configuration; defaults to +true+ (deprecated, removed in terraform
    #   0.15).
    # * +:input+: when +false+, will not ask for input for variables not
    #   directly set; defaults to +true+.
    # * +:lock+: when +true+, locks the state file when locking is supported;
    #   when +false+, does not lock the state file; defaults to +true+
    #   (deprecated, removed in terraform 0.15).
    # * +:lock_timeout+: the duration to retry a state lock; defaults to +"0s"+;
    #   (deprecated, removed in terraform 0.15).
    # * +:no_color+: whether or not the output from the command should be in
    #   color; defaults to +false+.
    # * +:plugin_dir+: the path to a directory containing plugin binaries; this
    #   overrides all default search paths for plugins, and prevents the
    #   automatic installation of plugins; if both +:plugin_dir+ and
    #   +:plugin_dirs+ are provided, all plugin directories will be passed to
    #   Terraform.
    # * +:plugin_dirs+: an array of paths to directories containing plugin
    #   binaries; this overrides all default search paths for plugins, and
    #   prevents the automatic installation of plugins; if both +:plugin_dir+
    #   and +:plugin_dirs+ are provided, all plugin directories will be passed
    #   to Terraform.
    # * +:reconfigure+: if +true+, reconfigures the backend, ignoring any saved
    #   configuration; defaults to +false+.
    # * +:upgrade+: if +true+, when installing modules or plugins, ignores
    #   previously-downloaded objects and installs the latest version allowed
    #   within configured constraints; defaults to +false+.
    # * +:verify_plugins+: whether or not to verify plugins for this
    #   configuration; defaults to +true+ (deprecated, removed in terraform
    #   0.15).
    # * +:lockfile+: sets a dependency lockfile mode; currently only "readonly"
    #   is valid.
    #
    # The {#execute} method accepts an optional second parameter which is a map
    # of invocation options. Currently, the only supported option is
    # +:environment+ which is a map of environment variables to expose during
    # invocation of the command.
    #
    # @example Basic Invocation
    #   RubyTerraform::Commands::Init.new.execute(
    #     from_module: 'some/module/path',
    #     path: 'infra/module')
    #
    class Init < Base
      include RubyTerraform::Options::Global

      # @!visibility private
      def subcommands
        %w[init]
      end

      # rubocop:disable Metrics/MethodLength

      # @!visibility private
      def options
        %w[
          -backend
          -backend-config
          -force-copy
          -from-module
          -get
          -get-plugins
          -input
          -lock
          -lock-timeout
          -no-color
          -plugin-dir
          -reconfigure
          -upgrade
          -verify-plugins
          -lockfile
        ] + super
      end

      # rubocop:enable Metrics/MethodLength

      # @!visibility private
      def arguments(parameters)
        [parameters[:path]]
      end

      # @!visibility private
      def parameter_defaults(_parameters)
        { backend_config: {} }
      end
    end
  end
end
