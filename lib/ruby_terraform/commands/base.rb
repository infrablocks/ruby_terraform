require 'lino'

module RubyTerraform
  module Commands
    class Base
      attr_reader :binary

      def initialize(binary: nil, logger: nil)
        @binary = binary || RubyTerraform.configuration.binary
        @logger = logger || RubyTerraform.configuration.logger
      end

      def stdin
        ''
      end

      def stdout
        $stdout
      end

      def stderr
        $stderr
      end

      def execute(opts = {})
        builder = instantiate_builder

        do_before(opts)
        command = configure_command(builder, opts)
                    .build
        @logger.debug "Running #{command.to_s}"

        command.execute(
          stdin: stdin,
          stdout: stdout,
          stderr: stderr
        )
        do_after(opts)
      end

      def instantiate_builder
        Lino::CommandLineBuilder
            .for_command(binary)
            .with_option_separator('=')
      end

      def do_before(opts)
      end

      def configure_command(builder, opts)
      end

      def do_after(opts)
      end
    end
  end
end
