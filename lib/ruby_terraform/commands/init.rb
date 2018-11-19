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
        source = opts[:from_module]
        path = opts[:path]
        plugin_dir = opts[:plugin_dir]
        force_copy = opts[:force_copy]

        builder = builder
            .with_subcommand('init') do |sub|
              sub = sub.with_option('-backend', backend) unless backend.nil?
              sub = sub.with_option('-force-copy', force_copy) unless force_copy.nil?
              sub = sub.with_option('-get', get) unless get.nil?
              sub = sub.with_option('-from-module', source) if source
              sub = sub.with_flag('-no-color') if no_color
              sub = sub.with_option('-plugin-dir', plugin_dir) unless plugin_dir.nil?
              backend_config.each do |key, value|
                sub = sub.with_option(
                    '-backend-config',
                    "'#{key}=#{value}'",
                    separator: ' ')
              end
              sub
            end

        builder = builder.with_argument(path) if path

        builder
      end
    end
  end
end
