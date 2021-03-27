require 'json'

module RubyTerraform
  module CommandLine
    class Option
      def initialize(opt_key, value, switch_override: nil)
        assign_option_value(value)
        @switch = switch_override || switch_from_key(opt_key)
      end

      def add_to_subcommand(sub)
        if value.respond_to?(:keys)
          add_hash_to_subcommand(sub, value)
        elsif value.respond_to?(:each)
          add_array_to_subcommand(sub, value)
        else
          add_option_to_subcommand(sub)
        end || sub
      end

      private

      attr_reader :switch, :value

      def assign_option_value(value)
        @value = value
      end

      def switch_from_key(opt_key)
        "-#{opt_key.to_s.sub('_', '-')}"
      end

      def add_hash_to_subcommand(sub, hash)
        hash.each do |hash_key, hash_value|
          sub = sub.with_option(switch, "'#{hash_key}=#{as_string(hash_value)}'", separator: ' ')
        end
        sub
      end

      def add_array_to_subcommand(sub, array)
        array.each do |element|
          sub = sub.with_option(switch, element)
        end
        sub
      end

      def add_option_to_subcommand(sub)
        if value
          sub.with_option(switch, value)
        else
          sub
        end
      end

      def as_string(value)
        value.is_a?(String) ? value : JSON.generate(value)
      end
    end
  end
end
