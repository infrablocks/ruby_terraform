module RubyTerraform
  class Output
    def self.for(opts)
      name = opts[:name]
      backend_config = opts[:backend_config]

      source_directory = opts[:source_directory]
      work_directory = opts[:work_directory]

      configuration_directory = File.join(work_directory, source_directory)

      FileUtils.mkdir_p File.dirname(configuration_directory)
      FileUtils.cp_r source_directory, configuration_directory

      Dir.chdir(configuration_directory) do
        RubyTerraform.init(backend_config: backend_config)
        RubyTerraform.output(name: name)
      end
    end
  end
end
