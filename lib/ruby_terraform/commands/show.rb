# frozen_string_literal: true

require 'lino'
require_relative 'base'

module RubyTerraform
  module Commands
    # Supports the `terraform show` directive
    class Show < Base
      def configure_command(builder, opts)
        no_color = opts[:no_color]
        module_depth = opts[:module_depth]
        builder
          .with_subcommand('show') do |sub|
          sub = sub.with_option('-module-depth', module_depth) if module_depth
          sub = sub.with_flag('-no-color') if no_color
          sub
        end
          .with_argument(opts[:directory])
      end
    end
  end
end
