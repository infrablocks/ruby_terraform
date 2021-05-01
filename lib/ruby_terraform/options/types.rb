# frozen_string_literal: true

require_relative 'types/standard'
require_relative 'types/flag'

module RubyTerraform
  module Options
    module Types
      def self.standard(name, value, **opts)
        Standard.new(name, value, **opts)
      end

      def self.flag(name, value)
        Flag.new(name, value)
      end

      def self.resolve(type)
        case type
        when :standard then Types::Standard
        when :flag then Types::Flag
        else type
        end
      end
    end
  end
end
