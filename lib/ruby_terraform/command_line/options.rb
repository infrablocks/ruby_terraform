require_relative 'option'
require_relative 'flag'
require_relative 'boolean_option'

module RubyTerraform
  module CommandLine
    class Options < Array
      def initialize(option_values:, command_arguments:)
        super()
        @option_values = option_values
        append_options_with_switch_overrides(command_arguments[:switch_overrides])
        append_options(command_arguments[:standard])
        append_boolean_options(command_arguments[:boolean])
        append_flags(command_arguments[:flags])
      end

      def self.global_options
        %i[chdir]
      end

      private

      attr_reader :option_values

      def append_options(options)
        Options.global_options.each { |opt_key| append(command_line_option(opt_key)) }
        (options || []).each { |opt_key| append(command_line_option(opt_key)) }
      end

      def append_options_with_switch_overrides(options)
        (options || {}).each do |opt_key, switch_override|
          append(command_line_option(opt_key, switch_override))
        end
      end

      def append_boolean_options(options)
        (options || []).each { |opt_key| append(BooleanOption.new(opt_key, option_values[opt_key])) }
      end

      def append_flags(options)
        (options || []).each { |opt_key| append(Flag.new(opt_key, option_values[opt_key])) }
      end

      def command_line_option(opt_key, switch_override = nil)
        Option.new(opt_key, option_values[opt_key], switch_override: switch_override)
      end
    end
  end
end
