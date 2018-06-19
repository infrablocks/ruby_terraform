require 'lino'
require_relative 'base'

module RubyTerraform
  module Commands
    class Apply < Base
      def configure_command(builder, opts)
        directory = opts[:directory]
        vars = opts[:vars] || {}
        var_file = opts[:var_file].kind_of?(String) ? opts[:var_file].lines : opts[:var_file] || []
        state = opts[:state]
        input = opts[:input]
        auto_approve = opts[:auto_approve]
        no_backup = opts[:no_backup]
        backup = no_backup ? '-' : opts[:backup]
        no_color = opts[:no_color]

        builder
            .with_subcommand('apply') do |sub|
              vars.each do |key, value|
                sub = sub.with_option('-var', "'#{key}=#{value}'", separator: ' ')
              end
              var_file.each do |file|
                sub = sub.with_option('-var-file', file)
              end
              sub = sub.with_option('-state', state) if state
              sub = sub.with_option('-input', input) if input
              sub = sub.with_option('-auto-approve', auto_approve) unless auto_approve.nil?
              sub = sub.with_option('-backup', backup) if backup
              sub = sub.with_flag('-no-color') if no_color
              sub
            end
            .with_argument(directory)
      end
    end
  end
end
