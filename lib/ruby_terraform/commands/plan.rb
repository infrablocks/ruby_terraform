# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Plan < Base
      include RubyTerraform::Options::Common

      def subcommands(_parameters)
        %w[plan]
      end

      def options # rubocop:disable Metrics/MethodLength
        %w[
          -compact-warnings
          -destroy
          -detailed-exitcode
          -input
          -lock
          -lock-timeout
          -no-color
          -out
          -parallelism
          -refresh
          -state
          -target
          -var
          -var-file
        ] + super
      end

      def arguments(parameters)
        [parameters[:directory]]
      end

      def parameter_defaults(_parameters)
        { vars: {}, var_files: [], targets: [] }
      end
    end
  end
end
