# frozen_string_literal: true

require_relative 'base'

module RubyTerraform
  module Commands
    class Format < Base
      def configure_command(builder, opts)
        directory = opts[:directory]
        check = opts[:check]
        diff = opts[:diff]
        list = opts[:list]
        no_color = opts[:no_color]
        recursive = opts[:recursive]
        write = opts[:write]

        builder.with_subcommand('fmt') do |sub|
          sub = sub.with_option('-list', list) if list
          sub = sub.with_option('-write', write) if write

          sub = sub.with_flag('-check') if check
          sub = sub.with_flag('-diff') if diff
          sub = sub.with_flag('-no-color') if no_color
          sub = sub.with_flag('-recursive') if recursive
          sub
        end.with_argument(directory)
      end
    end
  end
end
