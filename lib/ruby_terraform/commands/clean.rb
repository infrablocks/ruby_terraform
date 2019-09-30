require 'fileutils'

module RubyTerraform
  module Commands
    class Clean
      def initialize(directory: nil, logger: nil)
        @directory = directory ? directory : '.terraform'
        @logger = logger || RubyTerraform.configuration.logger
      end

      def execute(opts = {})
        directory = opts[:directory] || @directory
        @logger.info "Cleaning terraform directory '#{directory}'."
        FileUtils.rm_r(directory, :secure => true)
      rescue Errno::ENOENT => e
        @logger.error "Couldn't clean '#{directory}': #{e.message}"
      end
    end
  end
end
