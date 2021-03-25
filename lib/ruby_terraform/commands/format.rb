# frozen_string_literal: true

require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Format < Base
      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            boolean: %i[list write],
            flags: %i[check diff no_color recursive]
          }
        )
      end

      def command_line_commands(_option_values)
        'fmt'
      end

      def command_line_arguments(option_values)
        option_values[:directory]
      end
    end
  end
end
