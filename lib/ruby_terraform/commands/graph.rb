# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Graph < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[graph]
      end

      def options
        %w[
          -draw-cycles
          -type
          -module-depth
        ] + super
      end
    end
  end
end
