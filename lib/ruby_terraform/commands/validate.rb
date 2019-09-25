require 'lino'
require_relative 'base'

module RubyTerraform
  module Commands
    class Validate < Base
      def configure_command(builder, opts)
        directory = opts[:directory]
        vars = opts[:vars] || {}
        var_file = opts[:var_file]
        var_files = opts[:var_files] || []
        state = opts[:state]
        check_variables = opts[:check_variables]
        no_color = opts[:no_color]

        builder
            .with_subcommand('validate') do |sub|
              vars.each do |key, value|
                sub = sub.with_option(
                    '-var', "'#{key}=#{value}'", separator: ' ')
              end
              sub = sub.with_option('-var-file', var_file) if var_file
              var_files.each do |file|
                sub = sub.with_option('-var-file', file)
              end
              sub = sub.with_option('-state', state) if state
              sub = sub.with_option('-check-variables', check_variables) unless
                  check_variables.nil?
              sub = sub.with_flag('-no-color') if no_color
              sub
            end
            .with_argument(directory)
      end
    end
  end
end
