require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Plan < Base
      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            standard: %i[state target var_file],
            boolean: %i[input],
            flags: %i[destroy no_color],
            switch_overrides: { vars: '-var', targets: '-target', var_files: '-var-file', plan: '-out' }
          }
        )
      end

      def command_line_commands(_option_values)
        'plan'
      end

      def option_default_values(_opts)
        { vars: {}, var_files: [], targets: [] }
      end

      def command_line_arguments(option_values)
        option_values[:directory]
      end
    end
  end
end
