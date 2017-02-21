require 'fileutils'

module RubyTerraform
  module Commands
    class Clean
      def initialize(base_directory: nil)
        @directory = base_directory ? File.join(base_directory, '.terraform') : '.terraform'
      end

      def execute(opts = {})
        FileUtils.rm_rf(opts[:directory] || @directory)
      end
    end
  end
end