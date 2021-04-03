require 'json'
require_relative 'base'

module RubyTerraform
  module CommandLine
    module Option
      class Standard < Base
        def add_to_subcommand(sub)
          if value.respond_to?(:keys)
            add_hash_to_subcommand(sub)
          elsif value.respond_to?(:each)
            add_array_to_subcommand(sub)
          else
            sub.with_option(switch, value)
          end
        end

        private

        def add_hash_to_subcommand(sub)
          sub.with_repeated_option(
            switch,
            value.map do |hash_key, hash_value|
              "'#{hash_key}=#{as_string(hash_value)}'"
            end,
            separator: ' '
          )
        end

        def add_array_to_subcommand(sub)
          sub.with_repeated_option(switch, value)
        end

        def as_string(value)
          value.is_a?(String) ? value : JSON.generate(value)
        end
      end
    end
  end
end
