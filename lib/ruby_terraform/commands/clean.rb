require 'fileutils'

module RubyTerraform
  module Commands
    class Clean
      def initialize(directory: nil)
        @directory = directory ? directory : '.terraform'
        @logger = RubyTerraform.configure do |config|
          config.logger
        end
      end

      def execute(opts = {})
        @logger.info "Cleaning terraform directory #{opts[:directory] || @directory}"
        FileUtils.rm_r(opts[:directory] || @directory, :secure => true)
      end
    end
  end
end
