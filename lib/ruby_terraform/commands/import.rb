# frozen_string_literal: true

require 'lino'
require_relative 'base'

module RubyTerraform
  module Commands
    class Import < Base
      def configure_command(builder, opts)
        directory = opts[:directory]
        vars = opts[:vars] || {}
        var_file = opts[:var_file]
        var_files = opts[:var_files] || []
        no_color = opts[:no_color]
        no_backup = opts[:no_backup]
        backup = no_backup ? '-' : opts[:backup]
        state = opts[:state]
        input = opts[:input]
        address = opts[:address]
        id = opts[:id]

        builder
          .with_subcommand('import') do |sub|
            sub = sub.with_option('-config', directory)
            vars.each do |key, value|
              var_value = value.is_a?(String) ? value : JSON.generate(value)
              sub = sub.with_option(
                '-var', "'#{key}=#{var_value}'", separator: ' '
              )
            end
            sub = sub.with_option('-var-file', var_file) if var_file
            var_files.each do |file|
              sub = sub.with_option('-var-file', file)
            end
            sub = sub.with_option('-state', state) if state
            sub = sub.with_option('-input', input) if input
            sub = sub.with_option('-backup', backup) if backup
            sub = sub.with_flag('-no-color') if no_color
            sub
          end
          .with_argument(address)
          .with_argument(id)
      end
    end
  end
end
