require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Refresh < Base
      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            standard: %i[backup lock_timeout state state_out target var var_file],
            boolean: %i[input],
            flags: %i[compact_warnings lock no_color],
            switch_overrides: { targets: '-target', vars: '-var', var_files: '-var-file' }
          }
        )
      end

      def command_line_commands(_option_values)
        'refresh'
      end

      def command_line_arguments(option_values)
        option_values[:directory]
      end

      def option_default_values(_opts)
        { vars: {}, var_files: [], targets: [] }
      end
    end
  end
end
