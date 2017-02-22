require 'lino'
require_relative 'base'

module RubyTerraform
  module Commands
    class Output < Base
      def stdout
        @stdout ||= StringIO.new
      end

      def configure_command(builder, opts)
        name = opts[:name]
        state = opts[:state]
        no_color = opts[:no_color]

        builder = builder
            .with_subcommand('output') do |sub|
              sub = sub.with_flag('-no-color') if no_color
              sub = sub.with_option('-state', state) if state
              sub
            end
        builder = builder.with_argument(name) if name
        builder
      end

      def do_after(opts)
        result = stdout.string
        opts[:name] ? result.chomp : result
      end
    end
  end
end