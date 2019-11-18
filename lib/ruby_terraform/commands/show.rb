# frozen_string_literal: true

require 'lino'
require_relative 'base'

module RubyTerraform
  module Commands
    class Show < Base
      def configure_command(builder, opts)
        path = opts[:path] || opts[:directory]
        json_format = opts[:json]
        no_color = opts[:no_color]
        module_depth = opts[:module_depth]

        builder
          .with_subcommand('show') do |sub|
          sub = sub.with_option('-module-depth', module_depth) if module_depth
          sub = sub.with_flag('-no-color') if no_color
          sub = sub.with_flag('-json') if json_format
          sub
        end
          .with_argument(path)
      end
    end
  end
end
