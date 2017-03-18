require 'ruby_terraform/version'
require 'ruby_terraform/commands'

module RubyTerraform
  class << self
    attr_accessor :configuration

    def configure
      @configuration ||= Configuration.new
      yield(@configuration)
    end

    def reset!
      @configuration = nil
    end
  end

  module ClassMethods
    def clean(opts = {})
      Commands::Clean.new.execute(opts)
    end

    def get(opts = {})
      Commands::Get.new.execute(opts)
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

    def output(opts = {})
      Commands::Output.new.execute(opts)
    end
  end
  extend ClassMethods

  def self.included( other )
    other.extend( ClassMethods )
  end

  class Configuration
    attr_accessor :binary

    def initialize
      @binary = 'terraform'
    end
  end
end
