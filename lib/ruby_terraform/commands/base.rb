require 'lino'

module RubyTerraform
  module Commands
    class Base
      attr_reader :binary

      def initialize(binary: nil)
        @binary = binary || RubyTerraform.configuration.binary
      end

      def execute(opts)
        builder = Lino::CommandLineBuilder
            .for_command(binary)
            .with_option_separator('=')
        configure_command(builder, opts)
          .build
          .execute
      end

      def configure_command(builder, opts)
      end
    end
  end
end