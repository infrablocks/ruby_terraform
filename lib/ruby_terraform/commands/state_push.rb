# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class StatePush < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[state push]
      end

      def options
        %w[-ignore-remote-version] + super
      end

      def arguments(parameters)
        [parameters[:path]]
      end
    end
  end
end
