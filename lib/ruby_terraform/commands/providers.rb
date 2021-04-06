# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Providers < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[providers]
      end
    end
  end
end
