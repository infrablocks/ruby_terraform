# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class Logout < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[logout]
      end

      def arguments(parameters)
        [parameters[:hostname]]
      end
    end
  end
end
