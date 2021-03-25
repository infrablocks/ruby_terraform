# frozen_string_literal: true

require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Import < Base#
      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            standard: %i[backup state var_file],
            boolean: %i[input],
            flags: %i[no_color],
            switch_overrides: { directory: '-config', vars: '-var', var_files: '-var-file' }
          }
        )
      end

      def command_line_commands(_option_values)
        'import'
      end

      def command_line_arguments(option_values)
        [option_values[:address], option_values[:id]]
      end

      def option_default_values(_opts)
        { vars: {}, var_files: [] }
      end

      def option_override_values(opts)
        { backup: opts[:no_backup] ? '-' : opts[:backup] }
      end
    end
  end
end
