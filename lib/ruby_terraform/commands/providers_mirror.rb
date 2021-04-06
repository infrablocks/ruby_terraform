# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class ProvidersMirror < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[providers mirror]
      end

      def options
        %w[-platform] + super
      end

      def arguments(parameters)
        [parameters[:directory]]
      end
    end
  end
end
