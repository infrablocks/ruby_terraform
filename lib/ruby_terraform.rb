# frozen_string_literal: true

require 'ruby_terraform/version'
require 'ruby_terraform/errors'
require 'ruby_terraform/options'
require 'ruby_terraform/commands'
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
    # @option parameters [String] :directory The directory containing terraform
    #   configuration; required unless +:plan+ is provided.
    # @option parameters [String] :plan The path to a pre-computed plan to be
    #   applied; required unless +:directory+ is provided.
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
    #
    # @example Basic Invocation
    #   RubyTerraform.apply(
    #     directory: 'infra/networking',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    def apply(parameters = {})
      exec(RubyTerraform::Commands::Apply, parameters)
    end

    # Invokes the +terraform destroy+ command which destroys terraform managed
    # infrastructure.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :directory The directory containing terraform
    #   configuration; required.
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
    def destroy(parameters = {})
      exec(RubyTerraform::Commands::Destroy, parameters)
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
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :force (false) If +true+, does not ask for
    #   input for unlock confirmation.
    #
    # @example Basic Invocation
    #   RubyTerraform.force_unlock(
    #     lock_id: '50e844a7-ebb0-fcfd-da85-5cce5bd1ec90')
    #
    def force_unlock(parameters = {})
      exec(RubyTerraform::Commands::ForceUnlock, parameters)
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
    # @option parameters [String] :directory The directory containing terraform
    #   configuration.
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
    # @option parameters [Boolean] :recursive (false) If +true+, also processes
    #   files in subdirectories; by default, only the provided +:directory+ is
    #   processed.
    #
    # @example Basic Invocation
    #   RubyTerraform.format(
    #     directory: 'infra/networking')
    #
    def format(parameters = {})
      exec(RubyTerraform::Commands::Format, parameters)
    end

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
    # @option parameters [String] :directory The directory containing terraform
    #   configuration; required.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :update (false) If +true+, checks
    #   already-downloaded modules for available updates and installs the
    #   newest versions available.
    # @option parameters [Boolean] :no_color (false) Whether or not the output
    #   from the command should be in color.
    #
    # @example Basic Invocation
    #   RubyTerraform.get(
    #     directory: 'infra/networking')
    #
    def get(parameters = {})
      exec(RubyTerraform::Commands::Get, parameters)
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
    #
    # @example Basic Invocation
    #   RubyTerraform.graph
    #
    def graph(parameters = {})
      exec(RubyTerraform::Commands::Graph, parameters)
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
    # @option parameters [String] :directory The path to a directory of
    #   terraform configuration files to use to configure the provider; defaults
    #   to the current directory; if no config files are present, they must be
    #   provided via the input prompts or env vars.
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
    def import(parameters = {})
      exec(RubyTerraform::Commands::Import, parameters)
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
    #   current directory.
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
    #   and prevents the automatic installation of plugins.
    # @option parameters [Boolean] :reconfigure (false) If +true+, reconfigures
    #   the backend, ignoring any saved configuration.
    # @option parameters [Boolean] :upgrade (false) If +true+, when installing
    #   modules or plugins, ignores previously-downloaded objects and installs
    #   the latest version allowed within configured constraints.
    # @option parameters [Boolean] :verify_plugins (true) Whether or not to
    #   verify plugins for this configuration (deprecated, removed in terraform
    #   0.15).
    #
    # @example Basic Invocation
    #   RubyTerraform.init(
    #     from_module: 'some/module/path',
    #     path: 'infra/module')
    #
    def init(parameters = {})
      exec(RubyTerraform::Commands::Init, parameters)
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
    #
    # @example Basic Invocation
    #   RubyTerraform.login
    #
    def login(parameters = {})
      exec(RubyTerraform::Commands::Login, parameters)
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
    #
    # @example Basic Invocation
    #   RubyTerraform.logout
    #
    def logout(parameters = {})
      exec(RubyTerraform::Commands::Logout, parameters)
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
    #
    # @example Basic Invocation
    #   RubyTerraform.output(
    #     name: 'vpc_id')
    #
    def output(parameters = {})
      exec(RubyTerraform::Commands::Output, parameters)
    end

    # Invokes the +terraform plan+ command which generates a speculative
    # execution plan, showing what actions Terraform would take to apply the
    # current configuration. This command will not actually perform the planned
    # actions.
    #
    # You can optionally save the plan to a file, which you can then pass to
    # the {#apply} command to perform exactly the actions described in the plan.
    #
    # @param parameters The parameters used to invoke the command
    # @option parameters [String] :plan The path to output the plan if it should
    #   be saved to a file.
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
    #
    # @example Basic Invocation
    #   RubyTerraform.plan(
    #     directory: 'infra/networking',
    #     vars: {
    #       region: 'eu-central'
    #     })
    #
    def plan(parameters = {})
      exec(RubyTerraform::Commands::Plan, parameters)
    end

    {
      clean: RubyTerraform::Commands::Clean,
      providers: RubyTerraform::Commands::Providers,
      providers_lock: RubyTerraform::Commands::ProvidersLock,
      providers_mirror: RubyTerraform::Commands::ProvidersMirror,
      providers_schema: RubyTerraform::Commands::ProvidersSchema,
      refresh: RubyTerraform::Commands::Refresh,
      remote_config: RubyTerraform::Commands::RemoteConfig,
      show: RubyTerraform::Commands::Show,
      state_list: RubyTerraform::Commands::StateList,
      state_mv: RubyTerraform::Commands::StateMove,
      state_pull: RubyTerraform::Commands::StatePull,
      state_push: RubyTerraform::Commands::StatePush,
      state_replace_provider: RubyTerraform::Commands::StateReplaceProvider,
      state_rm: RubyTerraform::Commands::StateRemove,
      state_show: RubyTerraform::Commands::StateShow,
      taint: RubyTerraform::Commands::Taint,
      untaint: RubyTerraform::Commands::Untaint,
      validate: RubyTerraform::Commands::Validate,
      workspace_list: RubyTerraform::Commands::WorkspaceList,
      workspace_select: RubyTerraform::Commands::WorkspaceSelect,
      workspace_new: RubyTerraform::Commands::WorkspaceNew,
      workspace_delete: RubyTerraform::Commands::WorkspaceDelete,
      workspace_show: RubyTerraform::Commands::WorkspaceShow
    }.each do |method, command_class|
      define_method(method) do |parameters = {}|
        exec(command_class, parameters)
      end
    end

    def workspace(parameters = {}) # rubocop:disable Metrics/MethodLength
      case parameters[:operation]
      when nil, 'list'
        exec(RubyTerraform::Commands::WorkspaceList, parameters)
      when 'select'
        exec(RubyTerraform::Commands::WorkspaceSelect, parameters)
      when 'new'
        exec(RubyTerraform::Commands::WorkspaceNew, parameters)
      when 'delete'
        exec(RubyTerraform::Commands::WorkspaceDelete, parameters)
      when 'show'
        exec(RubyTerraform::Commands::WorkspaceShow, parameters)
      else
        raise(
          "Invalid operation '#{parameters[:operation]}' supplied to workspace"
        )
      end
    end

    private

    def exec(command_class, parameters)
      command_class.new.execute(parameters)
    end
  end
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
      @targets.each { |t| t.write(*args) }
    end

    def close
      @targets.each(&:close)
    end

    def reopen(*args)
      @targets.each { |t| t.reopen(*args) }
    end
  end
end
