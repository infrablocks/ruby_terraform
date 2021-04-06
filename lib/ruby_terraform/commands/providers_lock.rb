# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class ProvidersLock < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[providers lock]
      end

      def options
        %w[
          -fs-mirror
          -net-mirror
          -platform
        ] + super
      end

      def arguments(parameters)
        [parameters[:providers]]
      end
    end
  end
end
