# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Import < Base
      include RubyTerraform::Options::Common

      def subcommands(_parameters)
        %w[import]
      end

      def options # rubocop:disable Metrics/MethodLength
        %w[
          -config
          -backup
          -input
          -lock
          -lock-timeout
          -no-color
          -parallelism
          -provider
          -state
          -state-out
          -var
          -var-file
          -ignore-remote-version
        ] + super
      end

      def arguments(parameters)
        [parameters[:address], parameters[:id]]
      end

      def parameter_defaults(_parameters)
        { vars: {}, var_files: [] }
      end

      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
