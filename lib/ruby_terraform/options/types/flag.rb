# frozen_string_literal: true

require_relative 'base'
require_relative '../values/boolean'

module RubyTerraform
  module Options
    module Types
      class Flag < Base
        def apply(builder)
          value.resolve ? builder.with_flag(name) : builder
        end
      end
    end
  end
end
