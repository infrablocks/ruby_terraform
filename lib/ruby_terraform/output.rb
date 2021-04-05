module RubyTerraform
  class Output
    class << self
      def for(opts)
        Dir.chdir(create_config_directory(opts)) do
          RubyTerraform.init(backend_config: opts[:backend_config])
          RubyTerraform.output(name: opts[:name])
        end
      end

      private

      def create_config_directory(opts)
        source_directory = opts[:source_directory]
        work_directory = opts[:work_directory]

        configuration_directory = File.join(work_directory, source_directory)
        FileUtils.mkdir_p File.dirname(configuration_directory)
        FileUtils.cp_r source_directory, configuration_directory

        configuration_directory
      end
    end
  end
end
