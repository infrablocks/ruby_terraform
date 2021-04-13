# frozen_string_literal: true

require 'immutable-struct'

module RubyTerraform
  module Options
    module Types
      class Base < ImmutableStruct.new(:name, :value, :separator)
        def initialize(name, value, **opts)
          super(name: name, value: value, separator: opts[:separator])
        end

        def apply(_builder)
          raise 'not implemented'
        end
      end
    end
  end
end
