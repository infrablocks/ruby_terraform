require 'lino'
require_relative '../errors'

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
      end

      def execute(opts = {})
        builder = instantiate_builder

        do_before(opts)
        command = configure_command(builder, opts).build
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

      def instantiate_builder
        Lino::CommandLineBuilder
          .for_command(binary)
          .with_option_separator('=')
      end

      def do_before(opts); end

      def configure_command(builder, opts); end

      def do_after(opts); end
    end
  end
end
