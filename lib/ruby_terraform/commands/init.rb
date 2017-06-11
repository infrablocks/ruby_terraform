require 'lino'
require_relative 'base'

module RubyTerraform
  module Commands
    class Init < Base
      def configure_command(builder, opts)
        no_color = opts[:no_color]
        backend = opts[:backend]
        get = opts[:get]
        backend_config = opts[:backend_config] || {}
        source = opts[:source]
        path = opts[:path]

        builder = builder
            .with_subcommand('init') do |sub|
              sub = sub.with_option('-backend', backend) unless backend.nil?
              sub = sub.with_option('-get', get) unless get.nil?
              sub = sub.with_flag('-no-color') if no_color
              backend_config.each do |key, value|
                sub = sub.with_option(
                    '-backend-config',
                    "'#{key}=#{value}'",
                    separator: ' ')
              end
              sub
            end

        builder = builder.with_argument(source) if source
        builder = builder.with_argument(path) if path

        builder
      end
    end
  end
end
