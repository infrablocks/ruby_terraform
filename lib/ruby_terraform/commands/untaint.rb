# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Untaint < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[untaint]
      end

      def options
        %w[
          -allow-missing
          -backup
          -lock
          -lock-timeout
          -no-color
          -state
          -state-out
          -ignore-remote-version
        ] + super
      end

      def arguments(parameters)
        [parameters[:name]]
      end

      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
