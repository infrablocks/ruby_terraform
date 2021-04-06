# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Format < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[fmt]
      end

      def options
        %w[
          -list
          -write
          -diff
          -check
          -recursive
        ] + super
      end

      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
