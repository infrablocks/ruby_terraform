# frozen_string_literal: true

require_relative 'base'
require_relative '../options/common'

module RubyTerraform
  module Commands
    class WorkspaceShow < Base
      include RubyTerraform::Options::Common

      def subcommands
        %w[workspace show]
      end
    end
  end
end
