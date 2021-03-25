require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Destroy < Base
      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            standard: %i[backup state target var_file],
            boolean: %i[auto_approve],
            flags: %i[force no_color],
            switch_overrides: { vars: '-var', targets: '-target', var_files: '-var-file' }
          }
        )
      end

      def command_line_commands(_option_values)
        'destroy'
      end

      def command_line_arguments(option_values)
        option_values[:directory]
      end

      def option_default_values(_opts)
        { vars: {}, var_files: [], targets: [] }
      end

      def option_override_values(opts)
        { backup: opts[:no_backup] ? '-' : opts[:backup] }
      end
    end
  end
end
