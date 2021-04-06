# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Show < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[show]
      end

      def options
        %w[
          -json
          -no-color
        ] + super
      end

      def arguments(parameters)
        [parameters[:path] || parameters[:directory]]
      end
    end
  end
end
