require 'fileutils'

module RubyTerraform
  module Commands
    class Clean
      def initialize(directory: nil)
        @directory = directory ? directory : '.terraform'
      end

      def execute(opts = {})
        FileUtils.rm_r(opts[:directory] || @directory, :secure => true)
      end
    end
  end
end
