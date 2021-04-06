# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class StateList < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[state list]
      end

      def arguments(parameters)
        [parameters[:address]]
      end
    end
  end
end
