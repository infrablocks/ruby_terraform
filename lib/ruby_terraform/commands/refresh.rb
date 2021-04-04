# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Refresh < Base
      include RubyTerraform::Options::Common

      def subcommands(_parameters)
        %w[refresh]
      end

      def options # rubocop:disable Metrics/MethodLength
        %w[
          -backup
          -compact-warnings
          -input
          -lock
          -lock-timeout
          -no-color
          -parallelism
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
