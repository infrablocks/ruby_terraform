require_relative '../errors'
require_relative '../command_line/builder'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Base
      def initialize(binary: nil, logger: nil, stdin: nil, stdout: nil, stderr: nil)
        @binary = binary || RubyTerraform.configuration.binary
        @logger = logger || RubyTerraform.configuration.logger
        @stdin = stdin || RubyTerraform.configuration.stdin
        @stdout = stdout || RubyTerraform.configuration.stdout
        @stderr = stderr || RubyTerraform.configuration.stderr
        initialize_command
      end

      def execute(opts = {})
        do_before(opts)
        command = build_command(opts)
        logger.debug("Running '#{command}'.")
        command.execute(
          stdin: stdin,
          stdout: stdout,
          stderr: stderr
        )
        do_after(opts)
      rescue Open4::SpawnError
        message = "Failed while running '#{command_name}'."
        logger.error(message)
        raise Errors::ExecutionError, message
      end

      protected

      attr_reader :binary, :logger, :stdin, :stdout, :stderr

      def command_name
        self.class.to_s.split('::')[-1].downcase
      end

      def do_before(_opts); end

      def do_after(_opts); end

      private

      def initialize_command; end

      def build_command(opts)
        option_values = apply_option_defaults_and_overrides(opts)
        RubyTerraform::CommandLine::Builder.new(
          binary: @binary,
          command_line_commands: command_line_commands(option_values),
          command_line_options: command_line_options(option_values),
          command_line_arguments: command_line_arguments(option_values)
        ).build
      end

      def apply_option_defaults_and_overrides(opts)
        option_default_values(opts).merge(opts).merge(option_override_values(opts))
      end

      def option_default_values(_option_values)
        {}
      end

      def option_override_values(_option_values)
        {}
      end

      def command_line_commands(_option_values)
        []
      end

      def command_line_options(_option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: _option_values,
          command_arguments: {}
        )
      end

      def command_line_arguments(_option_values)
        []
      end
    end
  end
end
