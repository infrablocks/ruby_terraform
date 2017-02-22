require 'lino'
require_relative 'base'

module RubyTerraform
  module Commands
    class RemoteConfig < Base
      def configure_command(builder, opts)
        backend = opts[:backend]
        no_color = opts[:no_color]
        backend_config = opts[:backend_config] || {}

        builder
            .with_subcommand('remote')
            .with_subcommand('config') do |sub|
              sub = sub.with_option('-backend', backend) if backend
              backend_config.each do |key, value|
                sub = sub.with_option('-backend-config', "'#{key}=#{value}'", separator: ' ')
              end

              sub = sub.with_flag('-no-color') if no_color
              sub
            end
      end
    end
  end
end