require 'lino'

require_relative '../errors'
require_relative '../options/factory'

module RubyTerraform
  module Commands
    class Base
      def initialize(
        binary: nil, logger: nil, stdin: nil, stdout: nil, stderr: nil
      )
        @binary = binary || RubyTerraform.configuration.binary
        @logger = logger || RubyTerraform.configuration.logger
        @stdin = stdin || RubyTerraform.configuration.stdin
        @stdout = stdout || RubyTerraform.configuration.stdout
        @stderr = stderr || RubyTerraform.configuration.stderr
        initialize_command
      end

      def execute(parameters = {})
        do_before(parameters)
        build_and_execute_command(parameters)
        do_after(parameters)
      rescue Open4::SpawnError
        message = "Failed while running '#{command_name}'."
        logger.error(message)
        raise Errors::ExecutionError, message
      end

      protected

      attr_reader :binary, :logger, :stdin, :stdout, :stderr

      def build_and_execute_command(parameters)
        command = build_command(parameters)
        logger.debug("Running '#{command}'.")
        command.execute(
          stdin: stdin,
          stdout: stdout,
          stderr: stderr
        )
      end

      def command_name
        self.class.to_s.split('::')[-1].downcase
      end

      def do_before(_parameters); end

      def do_after(_parameters); end

      private

      def initialize_command; end

      def build_command(parameters)
        parameters = resolve_parameters(parameters)

        Lino::CommandLineBuilder
          .for_command(@binary)
          .with_options_after_subcommands
          .with_option_separator('=')
          .with_appliables(Options::Factory.from(options, parameters))
          .with_subcommands(subcommands(parameters))
          .with_arguments(arguments(parameters))
          .build
      end

      def resolve_parameters(parameters)
        parameter_defaults(parameters)
          .merge(parameters)
          .merge(parameter_overrides(parameters))
      end

      def parameter_defaults(_parameters)
        {}
      end

      def parameter_overrides(_parameters)
        {}
      end

      def subcommands(_values)
        []
      end

      def options
        []
      end

      def arguments(_values)
        []
      end
    end
  end
end
