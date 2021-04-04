# frozen_string_literal: true

require 'stringio'
require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Output < Base
      include RubyTerraform::Options::Common

      def initialize_command
        return if defined?(@stdout) && @stdout.respond_to?(:string)

        @stdout = StringIO.new
      end

      def subcommands(_parameters)
        %w[output]
      end

      def options
        %w[
          -json
          -raw
          -no-color
          -state
        ] + super
      end

      def arguments(parameters)
        [parameters[:name]]
      end

      def do_after(parameters)
        result = stdout.string
        parameters[:name] ? result.chomp : result
      end
    end
  end
end
