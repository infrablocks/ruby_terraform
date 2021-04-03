require_relative 'base'

module RubyTerraform
  module Commands
    class Show < Base
      def switches
        %w[-json -no-color -module-depth] + super
      end

      def sub_commands(_values)
        'show'
      end

      def arguments(values)
        values[:path] || values[:directory]
      end
    end
  end
end
