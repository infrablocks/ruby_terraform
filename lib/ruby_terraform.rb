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
      get: RubyTerraform::Commands::Get,
      import: RubyTerraform::Commands::Import,
      init: RubyTerraform::Commands::Init,
      output: RubyTerraform::Commands::Output,
      plan: RubyTerraform::Commands::Plan,
      refresh: RubyTerraform::Commands::Refresh,
      remote_config: RubyTerraform::Commands::RemoteConfig,
      show: RubyTerraform::Commands::Show,
      validate: RubyTerraform::Commands::Validate,
      workspace: RubyTerraform::Commands::Workspace
    }.each do |method, command_class|
      define_method(method) do |parameters = {}|
        command_class.new.execute(parameters)
      end
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
  end
end
