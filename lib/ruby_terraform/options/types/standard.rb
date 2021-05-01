# frozen_string_literal: true

module RubyTerraform
  module Options
    module Types
      class Standard < ImmutableStruct.new(
        :name,
        :value,
        :separator,
        :placement
      )
        def initialize(name, value, **opts)
          super(
            name: name, value: value,
            separator: opts[:separator],
            placement: opts[:placement]
          )
        end

        def apply(builder)
          builder.with_option(
            name,
            value.render,
            separator: separator,
            placement: placement
          )
        end
      end
    end
  end
end
