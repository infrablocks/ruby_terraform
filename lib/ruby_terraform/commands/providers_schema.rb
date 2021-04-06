# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class ProvidersSchema < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[providers schema]
      end

      def options
        %w[-json] + super
      end

      def parameter_overrides(_parameters)
        # Terraform 0.15 - at this time, the -json flag is a required option.
        { json: true }
      end
    end
  end
end
