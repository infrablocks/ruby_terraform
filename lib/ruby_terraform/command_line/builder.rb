require 'lino'

module RubyTerraform
  module CommandLine
    class Builder
      def initialize(binary:, command_line_commands:, command_line_options:, command_line_arguments:)
        @builder = instantiate_builder(binary)
        @command_line_commands = array_of(command_line_commands)
        @command_line_options = command_line_options
        @command_line_arguments = array_of(command_line_arguments)
      end

      def build
        configure_builder
        builder.build
      end

      private

      attr_reader :builder, :command_line_commands, :command_line_options, :command_line_arguments

      def configure_builder
        add_subcommands_and_options
        add_arguments
      end

      def add_subcommands_and_options
        command_line_commands[0...-1].each { |command| @builder = builder.with_subcommand(command) }
        @builder = builder.with_subcommand(command_line_commands[-1]) do |sub|
          command_line_options.inject(sub) do |sub, command_line_option|
            command_line_option.add_to_subcommand(sub)
          end
        end
      end

      def add_arguments
        command_line_arguments.each do |argument|
          @builder = builder.with_argument(argument) if argument
        end
      end

      def instantiate_builder(binary)
        Lino::CommandLineBuilder
          .for_command(binary)
          .with_option_separator('=')
      end

      def array_of(value)
        return value if value.respond_to?(:each)

        [value]
      end
    end
  end
end
