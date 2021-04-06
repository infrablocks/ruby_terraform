# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class StatePull < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[state pull]
      end
    end
  end
end
