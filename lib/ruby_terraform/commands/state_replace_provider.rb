# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class StateReplaceProvider < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[state replace-provider]
      end

      def options
        %w[
          -auto-approve
          -backup
          -lock
          -lock-timeout
          -state
          -ignore-remote-version
        ] + super
      end

      def arguments(parameters)
        [parameters[:from], parameters[:to]]
      end

      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
