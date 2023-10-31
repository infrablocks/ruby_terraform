# frozen_string_literal: true

require 'ruby_terraform/version'
require 'ruby_terraform/errors'
require 'ruby_terraform/options'
require 'ruby_terraform/commands'
require 'ruby_terraform/models'
require 'logger'

module RubyTerraform
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset!
      @configuration = nil
    end
  end

  # rubocop:disable Metrics/ModuleLength

  module ClassMethods
    # Invokes the +terraform apply+ command which creates or updates
    # infrastructure according to terraform configuration files in the provided
    # directory.
    #
    # By default, terraform will generate a new plan and present it for approval
    # before taking any action. Alternatively, the command accepts a plan file
    # created by a previous invocation, in which case terraform will take the
    # actions described in that plan without any confirmation prompt.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :plan The path to a pre-computed plan to be
    #   applied.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :auto_approve (false) If +true+, skips
    #   interactive approval of the generated plan before applying.
    # @option parameters [String] :backup The path to backup the existing state
    #   file before modifying; defaults to the +:state_out+ path with
    #   +".backup"+ extension; set +:no_backup+ to +true+ to skip backups
    #   entirely.
    # @option parameters [Boolean] :compact_warnings (false) When +true+, if
    #   terraform produces any warnings that are not accompanied by errors,
    #   they are shown in a more compact form that includes only the summary
    #   messages.
    # @option parameters [Boolean] :input (true) When +false+, will not ask for
    #   input for variables not directly set.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [Boolean] :no_backup (false) When +true+, no backup
    #   file will be written.
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @option parameters [Integer] :parallelism (10) The number of parallel
    #   resource operations.
    # @option parameters [Boolean] :refresh (true) When +true+, updates state
    #   prior to checking for differences; when +false+ uses locally available
    #   state; this has no effect when +:plan+ is provided.
    # @option parameters [String] :replace Force replacement of a resource
    #   instance using its resource address. If the apply would've normally
    #   produced an update or no-op action for this instance, Terraform will
    #   replace it instead.
    # @option parameters [Array<String>] :replaces An array of resource
    #   addresses to replace; if both +replace+ and +replaces+ are provided,
    #   all resources will be replaced.
    # @option parameters [String] :state ("terraform.tfstate") The path to the
    #   state file from which to read state and in which to store state (unless
    #   +:state_out+ is specified).
    # @option parameters [String] :state_out The path to write state to that is
    #   different than +:state+; this can be used to preserve the old state.
    # @option parameters [String] :target The address of a resource to target;
    #   if both +:target+ and +:targets+ are provided, all targets will be
    #   passed to terraform.
    # @option parameters [Array<String>] :targets An array of resource addresses
    #   to target; if both +:target+ and +:targets+ are provided, all targets
    #   will be passed to terraform.
    # @option parameters [Hash<String, Object>] :vars A map of variables to be
    #   passed to the terraform configuration.
    # @option parameters [String] :var_file The path to a terraform var file;
    #   if both +:var_file+ and +:var_files+ are provided, all var files will be
    #   passed to terraform.
    # @option parameters [Array<String>] :var_files An array of paths to
    #   terraform var files; if both +:var_file+ and +:var_files+ are provided,
    #   all var files will be passed to terraform.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.apply(
    #     directory: 'infra/networking',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    def apply(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Apply, parameters, invocation_options)
    end

    # Invokes the +terraform destroy+ command which destroys terraform managed
    # infrastructure.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :auto_approve (false) If +true+, skips
    #   interactive approval before destroying.
    # @option parameters [String] :backup The path to backup the existing state
    #   file before modifying; defaults to the +:state_out+ path with
    #   +".backup"+ extension; set +:no_backup+ to +true+ to skip backups
    #   entirely (legacy).
    # @option parameters [Boolean] :compact_warnings (false) When +true+, if
    #   terraform produces any warnings that are not accompanied by errors,
    #   they are shown in a more compact form that includes only the summary
    #   messages.
    # @option parameters [Boolean] :input (true) When +false+, will not ask for
    #   input for variables not directly set.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [Boolean] :no_backup (false) When +true+, no backup
    #   file will be written (legacy).
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @option parameters [Integer] :parallelism (10) The number of parallel
    #   resource operations.
    # @option parameters [Boolean] :refresh (true) When +true+, updates state
    #   prior to checking for differences; when +false+ uses locally available
    #   state.
    # @option parameters [String] :state ("terraform.tfstate") The path to the
    #   state file from which to read state and in which to store state (unless
    #   +:state_out+ is specified) (legacy).
    # @option parameters [String] :state_out The path to write state to that is
    #   different than +:state+; this can be used to preserve the old state
    #   (legacy).
    # @option parameters [String] :target The address of a resource to target;
    #   if both +:target+ and +:targets+ are provided, all targets will be
    #   passed to terraform.
    # @option parameters [Array<String>] :targets An array of resource addresses
    #   to target; if both +:target+ and +:targets+ are provided, all targets
    #   will be passed to terraform.
    # @option parameters [Hash<String, Object>] :vars A map of variables to be
    #   passed to the terraform configuration.
    # @option parameters [String] :var_file The path to a terraform var file;
    #   if both +:var_file+ and +:var_files+ are provided, all var files will be
    #   passed to terraform.
    # @option parameters [Array<String>] :var_files An array of paths to
    #   terraform var files; if both +:var_file+ and +:var_files+ are provided,
    #   all var files will be passed to terraform.
    #
    # @example Basic Invocation
    #   RubyTerraform.destroy(
    #     directory: 'infra/networking',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    def destroy(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Destroy,
           parameters, invocation_options)
    end

    # Invokes the +terraform force-unlock+ command which manually unlocks the
    # state for the defined configuration.
    #
    # This will not modify your infrastructure. This command removes the lock on
    # the state for the current workspace. The behavior of this lock is
    # dependent on the backend being used. Local state files cannot be unlocked
    # by another process.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :lock_id The lock ID output when attempting an
    #   operation that failed due to a lock; required.
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :force (false) If +true+, does not ask for
    #   input for unlock confirmation.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.force_unlock(
    #     lock_id: '50e844a7-ebb0-fcfd-da85-5cce5bd1ec90')
    #
    def force_unlock(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::ForceUnlock,
           parameters, invocation_options)
    end

    # Invokes the +terraform fmt+ command which rewrites all terraform
    # configuration files to a canonical format.
    #
    # Both configuration files (.tf) and variables files (.tfvars) are updated.
    # JSON files (.tf.json or .tfvars.json) are not modified.
    #
    # If +:directory+ is not specified in the parameters map then the current
    # working directory will be used. If +:directory+ is +"-"+ then content will
    # be read from the standard input. The given content must be in the
    # terraform language native syntax; JSON is not supported.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :list (false) If +true+, lists files whose
    #   formatting differs; always disabled if using standard input.
    # @option parameters [Boolean] :write (false) If +true+, writes to source
    #   files; always disabled if using standard input or +:check+ is +true+.
    # @option parameters [Boolean] :diff (false) If +true+, displays diffs of
    #   formatting changes.
    # @option parameters [Boolean] :check (false) If +true+, checks if the input
    #   is formatted; if any input is not properly formatted, an
    #   {RubyTerraform::Errors::ExecutionError} will be thrown.
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @option parameters [Boolean] :recursive (false) If +true+, also processes
    #   files in subdirectories; by default, only the provided +:directory+ is
    #   processed.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.format(
    #     directory: 'infra/networking')
    #
    def format(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Format,
           parameters, invocation_options)
    end
    alias fmt format

    # Invokes the +terraform get+ command which downloads and installs modules
    # needed for the given configuration.
    #
    # This recursively downloads all modules needed, such as modules imported by
    # the root and so on. If a module is already downloaded, it will not be
    # redownloaded or checked for updates unless +:update+ is +true+.
    #
    # Module installation also happens automatically by default as part of
    # the {.init} command, so you should rarely need to run this command
    # separately.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :update (false) If +true+, checks
    #   already-downloaded modules for available updates and installs the
    #   newest versions available.
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.get(
    #     directory: 'infra/networking')
    #
    def get(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Get,
           parameters, invocation_options)
    end

    # Invokes the +terraform graph+ command which outputs the visual execution
    # graph of terraform resources according to either the current configuration
    # or an execution plan.
    #
    # The graph is outputted in DOT format. The typical program that can
    # read this format is GraphViz, but many web services are also available to
    # read this format.
    #
    # The +:type+ option can be used to control the type of graph shown.
    # Terraform creates different graphs for different operations. See the
    # options below for the list of types supported. The default type is
    # +"plan"+ if a configuration is given, and +"apply"+ if a plan file is
    # passed as an argument.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [String] :plan Render the graph using the specified
    #   plan file instead of the configuration in the current directory.
    # @option parameters [Boolean] :draw_cycles (false) If +true+, highlights
    #   any cycles in the graph with colored edges; this helps when diagnosing
    #   cycle errors.
    # @option parameters [String] :type The type of graph to output; can be:
    #   +"plan"+, +"plan-destroy"+, +"apply"+, +"validate"+, +"input"+,
    #   +"refresh"+; defaults to +"apply"+ if +:plan+ is provided, +"plan"+
    #   otherwise.
    # @option parameters [Integer] :module_depth In prior versions of terraform,
    #   specified the depth of modules to show in the output (deprecated).
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.graph
    #
    def graph(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Graph,
           parameters, invocation_options)
    end

    # Invokes the +terraform import+ command which imports existing
    # infrastructure into your terraform state.
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
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :address The address to import the resource
    #   to; required.
    # @option parameters [String] :id The resource-specific ID identifying the
    #   resource being imported; required.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [String] :backup The path to backup the existing state
    #   file before modifying; defaults to the +:state_out+ path with
    #   +".backup"+ extension; set +:no_backup+ to +true+ to skip backups
    #   entirely (legacy).
    # @option parameters [Boolean] :allow_missing_config (false) Whether or not
    #   to allow import when no resource configuration block exists.
    # @option parameters [Boolean] :input (true) When +false+, will not ask for
    #   input for variables not directly set.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [Boolean] :no_backup (false) When +true+, no backup
    #   file will be written (legacy).
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @option parameters [Integer] :parallelism (10) The number of parallel
    #   resource operations.
    # @option parameters [String] :provider The provider configuration to use
    #   when importing the object; by default, terraform uses the provider
    #   specified in the configuration for the target resource, and that is the
    #   best behavior in most cases (deprecated).
    # @option parameters [String] :state ("terraform.tfstate") The path to the
    #   state file from which to read state and in which to store state (unless
    #   +:state_out+ is specified) (legacy).
    # @option parameters [String] :state_out The path to write state to that is
    #   different than +:state+; this can be used to preserve the old state
    #   (legacy).
    # @option parameters [Hash<String, Object>] :vars A map of variables to be
    #   passed to the terraform configuration.
    # @option parameters [String] :var_file The path to a terraform var file;
    #   if both +:var_file+ and +:var_files+ are provided, all var files will be
    #   passed to terraform.
    # @option parameters [Array<String>] :var_files An array of paths to
    #   terraform var files; if both +:var_file+ and +:var_files+ are provided,
    #   all var files will be passed to terraform.
    # @option parameters [Boolean] :ignore_remote_version (false) If +true+,
    #   when using the enhanced remote backend with Terraform Cloud, continue
    #   even if remote and local Terraform versions differ; this may result in
    #   an unusable Terraform Cloud workspace, and should be used with extreme
    #   caution.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.import(
    #     directory: 'infra/networking',
    #     address: 'a.resource.address',
    #     id: 'a-resource-id',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    def import(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Import,
           parameters, invocation_options)
    end

    # Invokes the +terraform init+ command which initializes a new or existing
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
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :path The path to initialize; defaults to the
    #   current directory (deprecated in terraform 0.14, removed in terraform
    #   0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :backend (true) Whether or not to configure
    #   the backend for this configuration.
    # @option parameters [Hash<String,Object>] :backend_config A map of backend
    #   specific configuration parameters.
    # @option parameters [Boolean] :force_copy (false) If +true+, suppresses
    #   prompts about copying state data; this is equivalent to providing a
    #   "yes" to all confirmation prompts.
    # @option parameters [String] :from_module copies the contents of the given
    #   module into the target directory before initialization.
    # @option parameters [Boolean] :get (true) Whether or not to download any
    #   modules for this configuration.
    # @option parameters [Boolean] :get_plugins (true) Whether or not to install
    #   plugins for this configuration (deprecated, removed in terraform 0.15).
    # @option parameters [Boolean] :input (true) When +false+, will not ask for
    #   input for variables not directly set.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file (deprecated, removed in terraform 0.15).
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock (deprecated, removed in terraform 0.15).
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @option parameters [String] :plugin_dir The path to a directory containing
    #   plugin binaries; this overrides all default search paths for plugins,
    #   and prevents the automatic installation of plugins; if both
    #   +:plugin_dir+ and +:plugin_dirs+ are provided, all plugin directories
    #   will be passed to Terraform.
    # @option parameters [Array<String>] :plugin_dirs+: An array of paths to
    #   directories containing plugin binaries; this overrides all default
    #   search paths for plugins, and prevents the automatic installation of
    #   plugins; if both +:plugin_dir+ and +:plugin_dirs+ are provided, all
    #   plugin directories will be passed to Terraform.
    # @option parameters [Boolean] :reconfigure (false) If +true+, reconfigures
    #   the backend, ignoring any saved configuration.
    # @option parameters [Boolean] :upgrade (false) If +true+, when installing
    #   modules or plugins, ignores previously-downloaded objects and installs
    #   the latest version allowed within configured constraints.
    # @option parameters [Boolean] :verify_plugins (true) Whether or not to
    #   verify plugins for this configuration (deprecated, removed in terraform
    #   0.15).
    # @option parameters [String] :lockfile Sets a dependency lockfile mode;
    #   currently only "readonly" is valid.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.init(
    #     from_module: 'some/module/path',
    #     path: 'infra/module')
    #
    def init(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Init,
           parameters, invocation_options)
    end

    # Invokes the +terraform login+ command which retrieves an authentication
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
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.login
    #
    def login(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Login,
           parameters, invocation_options)
    end

    # Invokes the +terraform logout+ command which removes locally-stored
    # credentials for specified hostname.
    #
    # Note: the API token is only removed from local storage, not destroyed on
    # the remote server, so it will remain valid until manually revoked.
    #
    # If no hostname is provided, the default hostname is app.terraform.io.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.logout
    #
    def logout(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Logout,
           parameters, invocation_options)
    end

    # Invokes the +terraform output+ command which reads an output variable from
    # a Terraform state file and prints the value. With no additional arguments,
    # output will display all the outputs for the root module. If +:name+ is not
    # specified, all outputs are printed.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :name The name of the output to read.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [String] :state The path to the state file to read;
    #   defaults to +"terraform.tfstate"+.
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @option parameters [Boolean] :json (false) If +true+, machine readable
    #   output will be printed in JSON format.
    # @option parameters [Boolean] :raw (false) If +true+, for value types that
    #   can be automatically converted to a string, will print the raw string
    #   directly, rather than a human-oriented representation of the value.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.output(
    #     name: 'vpc_id')
    #
    def output(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Output,
           parameters, invocation_options)
    end

    # Invokes the +terraform plan+ command which generates a speculative
    # execution plan, showing what actions Terraform would take to apply the
    # current configuration. This command will not actually perform the planned
    # actions.
    #
    # You can optionally save the plan to a file, which you can then pass to
    # the {#read} command to perform exactly the actions described in the plan.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :plan The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :compact_warnings (false) When +true+, if
    #   terraform produces any warnings that are not accompanied by errors,
    #   they are shown in a more compact form that includes only the summary
    #   messages.
    # @option parameters [Boolean] :destroy (false) When +true+, a plan will be
    #   generated to destroy all resources managed by the given configuration
    #   and state.
    # @option parameters [Boolean] :detailed_exitcode (false) Whether or not to
    #   return detailed exit codes when the command exits; this will change the
    #   meaning of exit codes to: 0 - Succeeded, diff is empty (no changes); 1 -
    #   Errored; 2 - Succeeded, there is a diff.
    # @option parameters [Boolean] :input (true) When +false+, will not ask for
    #   input for variables not directly set.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @option parameters [Integer] :parallelism (10) The number of parallel
    #   resource operations.
    # @option parameters [Boolean] :refresh (true) When +true+, updates state
    #   prior to checking for differences; when +false+ uses locally available
    #   state; this has no effect when +:plan+ is provided.
    # @option parameters [String] :replace Force replacement of a resource
    #   instance using its resource address. If the plan would've normally
    #   produced an update or no-op action for this instance, Terraform will
    #   plan to replace it instead.
    # @option parameters [Array<String>] :replaces An array of resource
    #   addresses to replace; if both +replace+ and +replaces+ are provided,
    #   all resources will be replaced.
    # @option parameters [String] :state ("terraform.tfstate") The path to the
    #   state file from which to read state and in which to store state (unless
    #   +:state_out+ is specified).
    # @option parameters [String] :target The address of a resource to target;
    #   if both +:target+ and +:targets+ are provided, all targets will be
    #   passed to terraform.
    # @option parameters [Array<String>] :targets An array of resource addresses
    #   to target; if both +:target+ and +:targets+ are provided, all targets
    #   will be passed to terraform.
    # @option parameters [Hash<String, Object>] :vars A map of variables to be
    #   passed to the terraform configuration.
    # @option parameters [String] :var_file The path to a terraform var file;
    #   if both +:var_file+ and +:var_files+ are provided, all var files will be
    #   passed to terraform.
    # @option parameters [Array<String>] :var_files An array of paths to
    #   terraform var files; if both +:var_file+ and +:var_files+ are provided,
    #   all var files will be passed to terraform.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.plan(
    #     directory: 'infra/networking',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    def plan(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Plan, parameters, invocation_options)
    end

    # Invokes the +terraform providers+ command which prints out a tree of
    # modules in the referenced configuration annotated with their provider
    # requirements.
    #
    # This provides an overview of all of the provider requirements across all
    # referenced modules, as an aid to understanding why particular provider
    # plugins are needed and why particular versions are selected.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.providers
    #
    def providers(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Providers,
           parameters, invocation_options)
    end

    # Invokes the +terraform providers lock+ command which writes out dependency
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
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :provider The provider source address for
    #   which the lock file should be updated; if both +:provider+ and
    #   +:providers+ are provided, all providers will be passed to Terraform.
    # @option parameters [Array<String>] :providers An array of provider source
    #   addresses for which the lock file should be updated; if both +:provider+
    #   and +:providers+ are provided, all providers will be passed to
    #   Terraform.
    # @option parameters [String] :providers The provider source addresses for
    #   which the lock file should be updated.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [String] :fs_mirror If provided, consults the given
    #   filesystem mirror directory instead of the origin registry for each of
    #   the given providers; this would be necessary to generate lock file
    #   entries for a provider that is available only via a mirror, and not
    #   published in an upstream registry; in this case, the set of valid
    #   checksums will be limited only to what Terraform can learn from the data
    #   in the mirror directory.
    # @option parameters [String] :net_mirror If provided, consults the given
    #   network mirror (given as a base URL) instead of the origin registry for
    #   each of the given providers; this would be necessary to generate lock
    #   file entries for a provider that is available only via a mirror, and not
    #   published in an upstream registry; in this case, the set of valid
    #   checksums will be limited only to what Terraform can learn from the data
    #   in the mirror indices.
    # @option parameters [String] :platform The target platform to request
    #   package checksums for; by default Terraform will request package
    #   checksums suitable only for the platform where you run this command;
    #   target names consist of an operating system and a CPU architecture; for
    #   example, "linux_amd64" selects the Linux operating system running on an
    #   AMD64 or x86_64 CPU; each provider is available only for a limited set
    #   of target platforms; if both +:platform+ and +:platforms+ are provided,
    #   all platforms will be passed to Terraform.
    # @option parameters [Array<String>] :platforms An array of target platforms
    #   to request package checksums for; see +:platform+ for more details; if
    #   both +:platform+ and +:platforms+ are provided, all platforms will be
    #   passed to Terraform.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.providers_lock(
    #     fs_mirror: "/usr/local/terraform/providers",
    #     platforms: ["windows_amd64", "darwin_amd64", "linux_amd64"],
    #     provider: "tf.example.com/ourcompany/ourplatform")
    #
    def providers_lock(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::ProvidersLock,
           parameters, invocation_options)
    end

    # Invokes the +terraform providers mirror+ command which saves local copies
    # of all required provider plugins.
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
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The directory to populate with the
    #   mirrored provider plugins.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [String] :platform The target platform to build a
    #   mirror for; by default Terraform will obtain plugin packages suitable
    #   for the platform where you run this command; target names consist of an
    #   operating system and a CPU architecture; for example, "linux_amd64"
    #   selects the Linux operating system running on an AMD64 or x86_64 CPU;
    #   each provider is available only for a limited set of target platforms;
    #   if both +:platform+ and +:platforms+ are provided, all platforms will be
    #   passed to Terraform.
    # @option parameters [Array<String>] :platforms An array of target platforms
    #   to build a mirror for for; see +:platform+ for more details; if both
    #   +:platform+ and +:platforms+ are provided, all platforms will be passed
    #   to Terraform.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.providers_mirror(
    #     directory: './plugins',
    #     platforms: ["windows_amd64", "darwin_amd64", "linux_amd64"])
    #
    def providers_mirror(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::ProvidersMirror,
           parameters, invocation_options)
    end

    # Invokes the +terraform providers schema+ command which prints out a json
    # representation of the schemas for all providers used in the current
    # configuration.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.providers_schema(
    #     directory: 'infra/networking')
    #
    def providers_schema(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::ProvidersSchema,
           parameters, invocation_options)
    end

    # Invokes the +terraform refresh+ command which updates the state file of
    # your infrastructure with metadata that matches the physical resources they
    # are tracking.
    #
    # This will not modify your infrastructure, but it can modify your state
    # file to update metadata. This metadata might cause new changes to occur
    # when you generate a plan or call apply next.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [String] :backup The path to backup the existing state
    #   file before modifying; defaults to the +:state_out+ path with
    #   +".backup"+ extension; set +:no_backup+ to +true+ to skip backups
    #   entirely (legacy).
    # @option parameters [Boolean] :compact_warnings (false) When +true+, if
    #   terraform produces any warnings that are not accompanied by errors,
    #   they are shown in a more compact form that includes only the summary
    #   messages.
    # @option parameters [Boolean] :input (true) When +false+, will not ask for
    #   input for variables not directly set.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [Boolean] :no_backup (false) When +true+, no backup
    #   file will be written (legacy).
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @option parameters [Integer] :parallelism (10) The number of parallel
    #   resource operations.
    # @option parameters [Boolean] :refresh (true) When +true+, updates state
    #   prior to checking for differences; when +false+ uses locally available
    #   state; this has no effect when +:plan+ is provided.
    # @option parameters [String] :state ("terraform.tfstate") The path to the
    #   state file from which to read state and in which to store state (unless
    #   +:state_out+ is specified) (legacy).
    # @option parameters [String] :state_out The path to write state to that is
    #   different than +:state+; this can be used to preserve the old state
    #   (legacy).
    # @option parameters [String] :target The address of a resource to target;
    #   if both +:target+ and +:targets+ are provided, all targets will be
    #   passed to terraform.
    # @option parameters [Array<String>] :targets An array of resource addresses
    #   to target; if both +:target+ and +:targets+ are provided, all targets
    #   will be passed to terraform.
    # @option parameters [Hash<String, Object>] :vars A map of variables to be
    #   passed to the terraform configuration.
    # @option parameters [String] :var_file The path to a terraform var file;
    #   if both +:var_file+ and +:var_files+ are provided, all var files will be
    #   passed to terraform.
    # @option parameters [Array<String>] :var_files An array of paths to
    #   terraform var files; if both +:var_file+ and +:var_files+ are provided,
    #   all var files will be passed to terraform.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.refresh(
    #     directory: 'infra/networking',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    def refresh(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Refresh, parameters, invocation_options)
    end

    # Invokes the +terraform show+ command which reads and outputs a Terraform
    # state or plan file in a human-readable form. If no path is specified, the
    # current state will be shown.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :path The path to a state file or plan to
    #   show.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @option parameters [Boolean] :json (false) If +true+, outputs the
    #   Terraform plan or state in a machine-readable form.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.show
    #
    def show(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Show,
           parameters, invocation_options)
    end

    # Invokes the +terraform state list+ command which lists resources in the
    # Terraform state.
    #
    # This command lists resource instances in the Terraform state. The address
    # option can be used to filter the instances by resource or module. If no
    # pattern is given, all resource instances are listed.
    #
    # The addresses must either be module addresses or absolute resource
    # addresses, such as:
    #
    # * +aws_instance.example+
    # * +module.example+
    # * +module.example.module.child+
    # * +module.example.aws_instance.example+
    #
    # An {RubyTerraform::Errors::ExecutionError} will be raised if any of the
    # resources or modules given as filter addresses do not exist in the state.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :address The module address or absolute
    #   resource address to filter by; if both +:address+ and +:addresses+ are
    #   provided, all addresses will be passed to Terraform.
    # @option parameters [Array<String>] :addresses An array of module addresses
    #   or absolute resource addresses to filter by; if both +:address+ and
    #   +:addresses+ are provided, all addresses will be passed to Terraform.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [String] :state The path to a Terraform state file to
    #   use to look up Terraform-managed resources; by default, Terraform will
    #   consult the state of the currently-selected workspace.
    # @option parameters [String] :id When provided, filters the results to
    #   include only instances whose resource types have an attribute named "id"
    #   whose value equals the given id string.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.state_list
    #
    def state_list(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::StateList,
           parameters, invocation_options)
    end

    # Invokes the +terraform state mv+ command which moves an item in the state.
    #
    # This command will move an item matched by the address given to the
    # destination address. This command can also move to a destination address
    # in a completely different state file.
    #
    # This can be used for simple resource renaming, moving items to and from
    # a module, moving entire modules, and more. And because this command can
    # also move data to a completely new state, it can also be used for
    # refactoring one configuration into multiple separately managed Terraform
    # configurations.
    #
    # This command will output a backup copy of the state prior to saving any
    # changes. The backup cannot be disabled. Due to the destructive nature
    # of this command, backups are required.
    #
    # If you're moving an item to a different state file, a backup will be
    # created for each state file.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :source The source address of the item to
    #   move; required.
    # @option parameters [String] :destination The destination address to move
    #   the item to; required.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :dry_run (false) When +true+, prints out what
    #   would've been moved but doesn't actually move anything.
    # @option parameters [String] :backup The path where Terraform should write
    #   the backup for the original state; this can't be disabled; if not set,
    #   Terraform will write it to the same path as the state file with a
    #   +".backup"+ extension.
    # @option parameters [String] :backup_out The path where Terraform should
    #   write the backup for the destination state; this can't be disabled; if
    #   not set, Terraform will write it to the same path as the destination
    #   state file with a +".backup"+ extension; this only needs to be specified
    #   if +:state_out+ is set to a different path than +:state+.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [String] :state the path to the source state file;
    #   defaults to the configured backend, or +"terraform.tfstate"+.
    # @option parameters [String] :state_out The path to the destination state
    #   file to write to; if this isn't specified, the source state file will be
    #   used; this can be a new or existing path.
    # @option parameters [Boolean] :ignore_remote_version (false) Whether or not
    #   to continue even if remote and local Terraform versions are
    #   incompatible; this may result in an unusable workspace, and should be
    #   used with extreme caution.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.state_move(
    #     source: 'packet_device.worker',
    #     destination: 'packet_device.helper')
    #
    def state_move(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::StateMove,
           parameters, invocation_options)
    end
    alias state_mv state_move

    # Invokes the +terraform state pull+ command which pulls the state from its
    # location, upgrades the local copy, and outputs it to stdout.
    #
    # This command "pulls" the current state and outputs it to stdout. As part
    # of this process, Terraform will upgrade the state format of the local copy
    # to the current version.
    #
    # The primary use of this is for state stored remotely. This command will
    # still work with local state but is less useful for this.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.state_pull
    #
    def state_pull(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::StatePull,
           parameters, invocation_options)
    end

    # Invokes the +terraform state push+ command which updates remote state from
    # a local state file.
    #
    # This command "pushes" a local state and overwrites remote state with a
    # local state file. The command will protect you against writing
    # an older serial or a different state file lineage unless you pass +true+
    # for the +:force+ option.
    #
    # This command works with local state (it will overwrite the local state),
    # but is less useful for this use case.
    #
    # If +:path+ is +"-"+, then this command will read the state to push from
    # stdin. Data from stdin is not streamed to the backend: it is loaded
    # completely (until pipe close), verified, and then pushed.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :path The path to the state file to push; when
    #   passed +"-"+ will read state from standard input.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :force (false) When +true+, writes the state
    #   even if lineages don't match or the remote serial is higher.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [Boolean] :ignore_remote_version Whether or not to
    #   continue even if remote and local Terraform versions are incompatible;
    #   this may result in an unusable workspace, and should be used with
    #   extreme caution.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.state_push(
    #     path: 'some/statefile.tfstate')
    #
    def state_push(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::StatePush,
           parameters, invocation_options)
    end

    # Invokes the +terraform state rm+ command which removes one or more items
    # from the Terraform state, causing Terraform to "forget" those items
    # without first destroying them in the remote system.
    #
    # This command removes one or more resource instances from the Terraform
    # state based on the addresses given. You can view and list the available
    # instances with {#state_list}.
    #
    # If you give the address of an entire module then all of the instances in
    # that module and any of its child modules will be removed from the state.
    #
    # If you give the address of a resource that has "count" or "for_each" set,
    # all of the instances of that resource will be removed from the state.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :address The module address or absolute
    #   resource address of the resource instance to remove; required unless
    #   +:addresses+ is supplied; if both +:address+ and +:addresses+ are
    #   provided, all addresses will be passed to Terraform.
    # @option parameters [Array<String>] :addresses An array of module addresses
    #   or absolute resource addresses of the resource instances to remove;
    #   required unless +:address+ is supplied; if both +:address+ and
    #   +:addresses+ are provided, all addresses will be passed to Terraform.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :dry+run (false) When +true+, prints out what
    #   would've been removed but doesn't actually remove anything.
    # @option parameters [String] :backup The path where Terraform should
    #   write the backup state.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [String] :state The path to the state file to update;
    #   defaults to the current workspace state.
    # @option parameters [Boolean] :ignore_remote_version (false) Whether or not
    #   to continue even if remote and local Terraform versions are
    #   incompatible; this may result in an unusable workspace, and should be
    #   used with extreme caution.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.state_remove(
    #     address: 'packet_device.worker')
    #
    def state_remove(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::StateRemove,
           parameters, invocation_options)
    end
    alias state_rm state_remove

    # Invoke the +terraform state replace-provider+ command which replaces
    # provider for resources in the Terraform state.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :from The fully qualified name of the provider
    #   to be replaced; required.
    # @option parameters [String] :to The fully qualified name of the provider
    #   to replace with; required.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :auto_approve (false) If +true+, skips
    #   interactive approval.
    # @option parameters [String] :backup The path where Terraform should write
    #   the backup for the state file; this can't be disabled; if not set,
    # 	Terraform will write it to the same path as the state file with a
    # 	".backup" extension.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [String] :state The path to the state file to update;
    #   defaults to the current workspace state.
    # @option parameters [Boolean] :ignore_remote_version (false) Whether or not
    #   to continue even if remote and local Terraform versions are
    #   incompatible; this may result in an unusable workspace, and should be
    #   used with extreme caution.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.state_replace_provider(
    #     from: 'hashicorp/aws',
    #     to: 'registry.acme.corp/acme/aws')
    #
    def state_replace_provider(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::StateReplaceProvider,
           parameters, invocation_options)
    end

    # Invokes the +terraform state show+ command which shows the attributes of a
    # resource in the Terraform state.
    #
    # This command shows the attributes of a single resource in the Terraform
    # state. The +:address+ argument must be used to specify a single resource.
    # You can view the list of available resources with {#state_list}.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :address The module address or absolute
    #   resource address of the resource instance to show; required.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.state_show(
    #     address: 'packet_device.worker')
    #
    def state_show(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::StateShow,
           parameters, invocation_options)
    end

    # Invokes the +terraform taint+ command which marks a resource instance as
    # not fully functional.
    #
    # Terraform uses the term "tainted" to describe a resource instance which
    # may not be fully functional, either because its creation partially failed
    # or because you've manually marked it as such using this command.
    #
    # This will not modify your infrastructure directly, but subsequent
    # Terraform plans will include actions to destroy the remote object and
    # create a new object to replace it.
    #
    # You can remove the "taint" state from a resource instance using the
    # {#untaint} command.
    #
    # The address is in the usual resource address syntax, such as:
    #
    # * +aws_instance.foo+
    # * <tt>aws_instance.bar[1]</tt>
    # * +module.foo.module.bar.aws_instance.baz+
    #
    # Use your shell's quoting or escaping syntax to ensure that the address
    # will reach Terraform correctly, without any special interpretation.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :address The module address or absolute
    #   resource address of the resource instance to taint; required.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :allow_missing (false) If +true+, the command
    #   will succeed (i.e., will not throw an
    #   {RubyTerraform::Errors::ExecutionError}) even if the resource is
    #   missing.
    # @option parameters [String] :backup The path to backup the existing state
    #   file before modifying; defaults to the +:state_out+ path with
    #   +".backup"+ extension; set +:no_backup+ to +true+ to skip backups
    #   entirely.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [Boolean] :no_backup (false) When +true+, no backup
    #   file will be written.
    # @option parameters [String] :state The path to the state file from which
    #   to read state and in which to store state (unless +:state_out+ is
    #   specified); defaults to +"terraform.tfstate"+.
    # @option parameters [String] :state_out The path to write state to that is
    #   different than +:state+; this can be used to preserve the old state.
    # @option parameters [Boolean] :ignore_remote_version (false) Whether or not
    #   to continue even if remote and local Terraform versions are
    #   incompatible; this may result in an unusable workspace, and should be
    #   used with extreme caution.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.taint(
    #     address: 'aws_security_group.allow_all')
    #
    def taint(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Taint,
           parameters, invocation_options)
    end

    # Invokes the +terraform untaint+ command which removes the 'tainted' state
    # from a resource instance.
    #
    # Terraform uses the term "tainted" to describe a resource instance
    # which may not be fully functional, either because its creation partially
    # failed or because you've manually marked it as such using the {#taint}
    # command.
    #
    # This command removes that state from a resource instance, causing
    # Terraform to see it as fully-functional and not in need of replacement.
    #
    # This will not modify your infrastructure directly. It only avoids
    # Terraform planning to replace a tainted instance in a future operation.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :name The name of the resource instance to
    #   untaint; required.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :allow_missing (false) If +true+, the command
    #   will succeed (i.e., will not throw an
    #   {RubyTerraform::Errors::ExecutionError}) even if the resource is
    #   missing.
    # @option parameters [String] :backup The path to backup the existing state
    #   file before modifying; defaults to the +:state_out+ path with
    #   +".backup"+ extension; set +:no_backup+ to +true+ to skip backups
    #   entirely.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout The duration to retry a state
    #   lock; defaults to +"0s"+.
    # @option parameters [Boolean] :no_backup (false) When +true+, no backup
    #   file will be written.
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @option parameters [String] :state The path to the state file from which
    #   to read state and in which to store state (unless +:state_out+ is
    #   specified); defaults to +"terraform.tfstate"+.
    # @option parameters [String] :state_out The path to write state to that is
    #   different than +:state+; this can be used to preserve the old state.
    # @option parameters [Boolean] :ignore_remote_version (false) Whether or not
    #   to continue even if remote and local Terraform versions are
    #   incompatible; this may result in an unusable workspace, and should be
    #   used with extreme caution.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.untaint(
    #     name: 'aws_security_group.allow_all')
    #
    def untaint(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Untaint,
           parameters, invocation_options)
    end

    # Invokes the +terraform validate+ command which checks whether a
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
    # validation without accessing any configured remote backend, use the
    # {#init} command passing +:backend+ as +false+.
    #
    # To verify configuration in the context of a particular run (a particular
    # target workspace, input variable values, etc), use the {#plan} command
    # instead, which includes an implied validation check.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :json (false) Whether or not to produce
    #   output in a machine-readable JSON format, suitable for use in text
    #   editor integrations and other automated systems; always disables color.
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.validate(
    #     directory: 'infra/networking')
    #
    def validate(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::Validate,
           parameters, invocation_options)
    end

    # Invokes the +terraform workspace delete+ command which deletes a
    # workspace.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :name The name of the workspace to delete;
    #   required.
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :force (false) Whether or not to remove a
    #   non-empty workspace; defaults to +false+.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.workspace_delete(
    #     name: 'example')
    #
    def workspace_delete(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::WorkspaceDelete,
           parameters, invocation_options)
    end

    # Invokes the +terraform workspace list+ command which lists workspaces.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir the path of a working directory to
    #   switch to before executing the given subcommand.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.workspace_list(
    #     directory: 'infra/networking')
    #
    def workspace_list(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::WorkspaceList,
           parameters, invocation_options)
    end

    # Invokes the +terraform workspace new+ command which creates a new
    # workspace.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :name The name of the workspace to create;
    #   required.
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :lock (true) When +true+, locks the state
    #   file when locking is supported; when +false+, does not lock the state
    #   file.
    # @option parameters [String] :lock_timeout ("0s") The duration to retry a
    #   state lock.
    # @option parameters [String] :state The path to a state file to copy into
    #   the new workspace.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.workspace_new(
    #     name: 'example')
    #
    def workspace_new(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::WorkspaceNew,
           parameters, invocation_options)
    end

    # Invokes the +terraform workspace select+ command which selects a
    # workspace.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :name The name of the workspace to select;
    #   required.
    # @option parameters [String] :directory The path to a directory containing
    #   terraform configuration (deprecated in terraform 0.14, removed in
    #   terraform 0.15, use +:chdir+ instead).
    # @option parameters [Boolean] :or_create Whether to create the workspace if
    #   it does not exist.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example BasicInvocation
    #   RubyTerraform.workspace_select(
    #     name: 'example')
    #
    def workspace_select(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::WorkspaceSelect,
           parameters, invocation_options)
    end

    # Invokes the +terraform workspace show+ command which shows the name of the
    # current workspace.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @param [Hash<String, Object>] invocation_options Additional options
    #   controlling the invocation of the command.
    # @option invocation_options [Hash<String, String>] :environment A map
    #   of environment variables to expose at command invocation time.
    #
    # @example Basic Invocation
    #   RubyTerraform.workspace_show
    #
    def workspace_show(parameters = {}, invocation_options = {})
      exec(RubyTerraform::Commands::WorkspaceShow,
           parameters, invocation_options)
    end

    # rubocop:disable Metrics/MethodLength

    def workspace(parameters = {}, invocation_options = {})
      case parameters[:operation]
      when nil, 'list'
        exec(RubyTerraform::Commands::WorkspaceList,
             parameters, invocation_options)
      when 'select'
        exec(RubyTerraform::Commands::WorkspaceSelect,
             parameters, invocation_options)
      when 'new'
        exec(RubyTerraform::Commands::WorkspaceNew,
             parameters, invocation_options)
      when 'delete'
        exec(RubyTerraform::Commands::WorkspaceDelete,
             parameters, invocation_options)
      when 'show'
        exec(RubyTerraform::Commands::WorkspaceShow,
             parameters, invocation_options)
      else
        raise(
          "Invalid operation '#{parameters[:operation]}' supplied to workspace"
        )
      end
    end

    # rubocop:enable Metrics/MethodLength

    private

    def exec(command_class, parameters, invocation_options)
      command_class.new.execute(parameters, invocation_options)
    end
  end

  # rubocop:enable Metrics/ModuleLength

  extend ClassMethods

  def self.included(other)
    other.extend(ClassMethods)
  end

  class Configuration
    attr_accessor :binary, :logger, :options, :stdin, :stdout, :stderr

    def default_logger
      logger = Logger.new($stdout)
      logger.level = Logger::INFO
      logger
    end

    def default_options
      Options::Factory.new(Options::DEFINITIONS)
    end

    def initialize
      @binary = 'terraform'
      @logger = default_logger
      @options = default_options
      @stdin = ''
      @stdout = $stdout
      @stderr = $stderr
    end
  end

  class MultiIO
    def initialize(*targets)
      @targets = targets
    end

    def write(*args)
      @targets.collect { |t| t.write(*args) }.max
    end

    def <<(obj)
      write(obj)
      self
    end

    def close
      @targets.each(&:close)
      nil
    end

    def reopen(*args)
      @targets = @targets.collect { |t| t.reopen(*args) }
      self
    end
  end
end
