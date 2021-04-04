# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Get < Base
      include RubyTerraform::Options::Common

      def subcommands(_parameters)
        %w[get]
      end

      def options
        %w[
          -no-color
          -update
        ] + super
      end

      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
