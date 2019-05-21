require 'ruby_terraform/version'
require 'ruby_terraform/commands'

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
    def clean(opts = {})
      Commands::Clean.new.execute(opts)
    end

    def init(opts = {})
      Commands::Init.new.execute(opts)
    end

    def get(opts = {})
      Commands::Get.new.execute(opts)
    end

    def validate(opts = {})
      Commands::Validate.new.execute(opts)
    end

    def plan(opts = {})
      Commands::Plan.new.execute(opts)
    end

    def apply(opts = {})
      Commands::Apply.new.execute(opts)
    end

    def destroy(opts = {})
      Commands::Destroy.new.execute(opts)
    end

    def remote_config(opts = {})
      Commands::RemoteConfig.new.execute(opts)
    end

    def refresh(opts = {})
      Commands::Refresh.new.execute(opts)
    end

    def output(opts = {})
      Commands::Output.new.execute(opts)
    end

    def workspace(opts = {})
      Commands::Workspace.new.execute(opts)
    end

    def output_from_remote(opts)
      output_name = opts[:name]
      remote_opts = opts[:remote]

      clean
      remote_config(remote_opts)
      output(name: output_name)
    end
  end
  extend ClassMethods

  def self.included(other)
    other.extend(ClassMethods)
  end

  class Configuration
    attr_accessor :binary

    def initialize
      @binary = 'terraform'
    end
  end
end
