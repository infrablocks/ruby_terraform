# frozen_string_literal: true

require_relative 'name'

module RubyTerraform
  module Options
    class Factory
      def initialize(definitions)
        @definitions = definitions
      end

      def resolve(names, parameters)
        names
          .map { |name| Name.new(name) }
          .inject([]) do |options, name|
            options + resolve_name(name, parameters)
          end
      end

      private

      def resolve_name(name, parameters)
        @definitions.find { |d| d.matches?(name) }.build(parameters)
      end
    end
  end
end
