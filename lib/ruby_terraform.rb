module RubyTerraform
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.reset!
    self.configuration = nil
  end

  class Configuration
    attr_accessor :binary

    def initialize
      @binary = 'terraform'
    end
  end
end

require 'ruby_terraform/version'
require 'ruby_terraform/commands'
