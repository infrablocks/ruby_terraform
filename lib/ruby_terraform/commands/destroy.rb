require 'lino'
require_relative 'base'

module RubyTerraform
  module Commands
    class Destroy < Base
      def configure_command(builder, opts)
        directory = opts[:directory]
        vars = opts[:vars] || {}
        state = opts[:state]
        force = opts[:force]
        no_backup = opts[:no_backup]
        backup = no_backup ? '-' : opts[:backup]
        no_color = opts[:no_color]

        builder
            .with_subcommand('destroy') do |sub|
              vars.each do |key, value|
                sub = sub.with_option('-var', "'#{key}=#{value}'", separator: ' ')
              end
              sub = sub.with_option('-state', state) if state
              sub = sub.with_option('-backup', backup) if backup
              sub = sub.with_flag('-no-color') if no_color
              sub = sub.with_flag('-force') if force
              sub
            end
            .with_argument(directory)
      end
    end
  end
end