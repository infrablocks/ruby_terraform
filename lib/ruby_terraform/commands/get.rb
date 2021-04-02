require_relative 'base'

module RubyTerraform
  module Commands
    class Get < Base
      def configure_command(builder, opts)
        builder
            .with_subcommand('get') do |sub|
              sub = sub.with_option('-update', true) if opts[:update]
              sub = sub.with_flag('-no-color') if opts[:no_color]
              sub
            end
            .with_argument(opts[:directory])
      end
    end
  end
end
