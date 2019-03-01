require 'lino'
require 'stringio'
require_relative 'base'

module RubyTerraform
  module Commands
    class Apply < Base
      def stdout
        @stdout ||= StringIO.new
      end

      def configure_command(builder, opts)
        directory = opts[:directory]
        vars = opts[:vars] || {}
        var_file = opts[:var_file]
        var_files = opts[:var_files] || []
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
              sub = sub.with_option('-var-file', var_file) if var_file
              var_files.each do |file|
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

      def do_after(opts)
        parse_apply_output(stdout.string)
      end

      private
      def parse_apply_output(apply_output)
        output_header = "Outputs:"
        bash_colour_indicator = "\e"

        return '' unless apply_output.include? output_header

        apply_output.split(output_header)
            .last
            .split(bash_colour_indicator)
            .first
            .strip
      end
    end
  end
end
