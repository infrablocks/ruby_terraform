require 'lino'

module RubyTerraform
  module Commands
    class Base
      attr_reader :binary

      def initialize(binary: nil)
        @binary = binary || RubyTerraform.configuration.binary
      end

      def stdin
        ''
      end

      def stdout
        STDOUT
      end

      def stderr
        STDERR
      end

      def execute(opts = {})
        builder = instantiate_builder

        do_before(opts)
        configure_command(builder, opts)
          .build
          .execute(
              stdin: stdin,
              stdout: stdout,
              stderr: stderr)
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