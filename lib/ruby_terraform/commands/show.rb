# frozen_string_literal: true

require_relative 'base'
require_relative '../command_line/options'

module RubyTerraform
  module Commands
    class Show < Base
      def command_line_options(option_values)
        RubyTerraform::CommandLine::Options.new(
          option_values: option_values,
          command_arguments: {
            flags: %i[json no_color]
          }
        )
      end

      def command_line_commands(_option_values)
        'show'
      end

      def command_line_arguments(option_values)
        option_values[:path] || option_values[:directory]
      end
    end
  end
end
