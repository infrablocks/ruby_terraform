# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Taint < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[taint]
      end

      def options
        %w[
          -allow-missing
          -backup
          -lock
          -lock-timeout
          -state -state-out
          -ignore-remote-version
        ] + super
      end

      def arguments(parameters)
        [parameters[:address]]
      end

      def parameter_overrides(parameters)
        { backup: parameters[:no_backup] ? '-' : parameters[:backup] }
      end
    end
  end
end
