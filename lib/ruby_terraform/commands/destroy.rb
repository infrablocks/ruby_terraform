# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Destroy < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[destroy]
      end

      def options # rubocop:disable Metrics/MethodLength
        %w[
          -backup
          -compact-warnings
          -lock
          -lock-timeout
          -input
          -auto-approve
          -no-color
          -parallelism
          -refresh
          -state
          -state-out
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

      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
