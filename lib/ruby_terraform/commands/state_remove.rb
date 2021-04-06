# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class StateRemove < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[state rm]
      end

      def options
        %w[
          -backup
          -state
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
