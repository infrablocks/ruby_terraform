# frozen_string_literal: true

module RubyTerraform
  class Output
    class << self
      def for(parameters)
        Dir.chdir(create_config_directory(parameters)) do
          RubyTerraform.init(backend_config: parameters[:backend_config])
          RubyTerraform.output(parameters)
        end
      end

      private

      def create_config_directory(parameters)
        source_directory = parameters[:source_directory]
        work_directory = parameters[:work_directory]

        configuration_directory = File.join(work_directory, source_directory)
        FileUtils.mkdir_p File.dirname(configuration_directory)
        FileUtils.cp_r source_directory, configuration_directory

        configuration_directory
      end
    end
  end
end
