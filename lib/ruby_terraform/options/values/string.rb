# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Options
    module Values
      class String < Base
        def resolve
          @value.to_s
        end

        alias render resolve
      end
    end
  end
end
