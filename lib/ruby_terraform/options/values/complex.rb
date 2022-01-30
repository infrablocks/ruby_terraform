# frozen_string_literal: true

require 'json'

require_relative 'base'

module RubyTerraform
  module Options
    module Values
      class Complex < Base
        def resolve
          @value
        end

        def render
          @value.is_a?(::String) ? @value : JSON.generate(value)
        end
      end
    end
  end
end
