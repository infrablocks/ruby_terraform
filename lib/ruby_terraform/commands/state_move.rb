# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class StateMove < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[state mv]
      end

      def options
        %w[
          -backup
          -backup-out
          -state
          -state-out
          -ignore-remote-version
        ] + super
      end

      def arguments(parameters)
        [parameters[:source], parameters[:destination]]
      end

      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
