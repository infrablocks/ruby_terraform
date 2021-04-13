# frozen_string_literal: true

require 'json'

require_relative 'base'

module RubyTerraform
  module Options
    module Types
      class Standard < Base
        def apply(builder)
          builder.with_option(name, value.render, separator: separator)
        end
      end
    end
  end
end
