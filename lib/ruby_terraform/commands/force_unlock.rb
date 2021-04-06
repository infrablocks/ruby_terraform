# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class ForceUnlock < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[force-unlock]
      end

      def options
        %w[-force] + super
      end

      def arguments(parameters)
        [parameters[:lock_id]]
      end
    end
  end
end
