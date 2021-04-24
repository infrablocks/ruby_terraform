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
    # @option parameters [Boolean] :auto_approve (false) If +true+, skips
    #   interactive approval of the generated plan before applying.
    # @option parameters [String] :backup The path to backup the existing state
    #   file before modifying; defaults to the +:state_out+ path with
    #   +".backup"+ extension; set +:no_backup+ to +true+ to skip backups
    #   entirely.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
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
    # @option parameters [Boolean] :auto_approve (false) If +true+, skips
    #   interactive approval before destroying.
    # @option parameters [String] :backup The path to backup the existing state
    #   file before modifying; defaults to the +:state_out+ path with
    #   +".backup"+ extension; set +:no_backup+ to +true+ to skip backups
    #   entirely.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
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
    #   state.
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
    # @option parameters [String] :lock_id The directory containing terraform
    #   configuration; required.
    # @option parameters [String] :chdir The path of a working directory to
    #   switch to before executing the given subcommand.
    # @option parameters [Boolean] :force (false) If +true+, does not ask for input for
    #   unlock confirmation.
    #
    # @example Basic Invocation
    #   RubyTerraform.force_unlock(
    #     lock_id: '50e844a7-ebb0-fcfd-da85-5cce5bd1ec90')
    #
    def force_unlock(parameters = {})
      exec(RubyTerraform::Commands::ForceUnlock, parameters)
    end

    {
      clean: RubyTerraform::Commands::Clean,
      format: RubyTerraform::Commands::Format,
      get: RubyTerraform::Commands::Get,
      graph: RubyTerraform::Commands::Graph,
      import: RubyTerraform::Commands::Import,
      init: RubyTerraform::Commands::Init,
      login: RubyTerraform::Commands::Login,
      logout: RubyTerraform::Commands::Logout,
      output: RubyTerraform::Commands::Output,
      plan: RubyTerraform::Commands::Plan,
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
