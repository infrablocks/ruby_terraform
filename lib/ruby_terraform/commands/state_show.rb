# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class StateShow < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[state show]
      end

      def options
        %w[-state] + super
      end

      def arguments(parameters)
        [parameters[:address]]
      end
    end
  end
end
