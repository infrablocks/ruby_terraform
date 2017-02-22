require 'ruby_terraform/version'
require 'ruby_terraform/commands'

module RubyTerraform
  class << self
    attr_accessor :configuration

    def configure
      @configuration ||= Configuration.new
      yield(@configuration)
    end

    def clean(opts = {})
      Commands::Clean.new.execute(opts)
    end

    def get(opts = {})
      Commands::Get.new.execute(opts)
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

    def reset!
      @configuration = nil
    end
  end

  class Configuration
    attr_accessor :binary

    def initialize
      @binary = 'terraform'
    end
  end
end
