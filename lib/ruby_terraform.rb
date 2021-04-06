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
    {
      apply: RubyTerraform::Commands::Apply,
      clean: RubyTerraform::Commands::Clean,
      destroy: RubyTerraform::Commands::Destroy,
      format: RubyTerraform::Commands::Format,
      force_unlock: RubyTerraform::Commands::ForceUnlock,
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
        command_class.new.execute(parameters)
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
        raise "Invalid operation '#{parameters[:operation]}' supplied to workspace"
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
    attr_accessor :binary, :logger, :stdin, :stdout, :stderr

    def default_logger
      logger = Logger.new($stdout)
      logger.level = Logger::INFO
      logger
    end

    def initialize
      @binary = 'terraform'
      @logger = default_logger
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
