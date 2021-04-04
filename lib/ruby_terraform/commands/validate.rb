# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Validate < Base
      include RubyTerraform::Options::Common

      def subcommands(_parameters)
        %w[validate]
      end

      def options
        %w[
          -json
          -no-color
        ] + super
      end

      def arguments(parameters)
        [parameters[:directory]]
      end

      def parameter_defaults(_parameters)
        { vars: {}, var_files: [] }
      end
    end
  end
end
