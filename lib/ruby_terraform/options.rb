# frozen_string_literal: true

require_relative 'options/name'
require_relative 'options/types'
require_relative 'options/values'
require_relative 'options/definition'
require_relative 'options/factory'
require_relative 'options/common'

module RubyTerraform
  module Options
    def self.name(name)
      Name.new(name)
    end

    def self.definition(opts)
      Definition.new(opts)
    end

    def self.types
      Types
    end

    def self.values
      Values
    end
  end
end

require_relative 'options/definitions'
