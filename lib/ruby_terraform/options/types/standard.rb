require 'json'

require_relative 'base'

module RubyTerraform
  module Options
    module Types
      class Standard < Base
        def apply(builder)
          if value.respond_to?(:keys)
            apply_hash(builder)
          elsif value.respond_to?(:each)
            apply_array(builder)
          else
            builder.with_option(name, value)
          end
        end

        private

        def apply_hash(builder)
          builder.with_repeated_option(
            name,
            value.map do |hash_key, hash_value|
              "'#{hash_key}=#{as_string(hash_value)}'"
            end,
            separator: ' '
          )
        end

        def apply_array(builder)
          builder.with_repeated_option(name, value)
        end

        def as_string(value)
          value.is_a?(String) ? value : JSON.generate(value)
        end
      end
    end
  end
end
