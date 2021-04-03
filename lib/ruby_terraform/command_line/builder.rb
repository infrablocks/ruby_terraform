require 'lino'

module RubyTerraform
  module CommandLine
    class Builder
      def initialize(binary:, sub_commands:, options:, arguments:)
        @builder = instantiate_builder(binary)
        @sub_commands = array_of(sub_commands)
        @options = array_of(options)
        @arguments = array_of(arguments)
      end

      def build
        configure_builder
        builder.build
      end

      private

      attr_reader :builder, :sub_commands, :options, :arguments

      def configure_builder
        add_subcommands_and_options
        add_arguments
      end

      def add_subcommands_and_options
        sub_commands[0...-1].each do |command|
          @builder = builder.with_subcommand(command)
        end
        @builder = builder.with_subcommand(sub_commands.last) do |sub|
          options.inject(sub) do |sub_command, option|
            option.add_to_subcommand(sub_command)
          end
        end
      end

      def add_arguments
        @builder = builder.with_arguments(arguments)
      end

      def instantiate_builder(binary)
        Lino::CommandLineBuilder
          .for_command(binary)
          .with_option_separator('=')
      end

      def array_of(value)
        return value if value.respond_to?(:each)

        value.nil? ? [] : [value]
      end
    end
  end
end
