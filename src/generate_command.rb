require "pathname"

module Foobara
  module Generators
    module CommandGenerator
      class GenerateCommand < Foobara::Generators::Generate
        class MissingManifestError < RuntimeError; end

        possible_error MissingManifestError

        inputs CommandConfig

        def execute
          add_initial_elements_to_generate

          each_element_to_generate do
            generate_element
          end

          generate_generated_files_json

          paths_to_source_code
        end

        attr_accessor :command_config, :manifest_data

        def base_generator
          Generators::ProjectGenerator
        end

        def templates_dir
          "#{__dir__}/../templates"
        end

        def add_initial_elements_to_generate
          elements_to_generate << command_config
        end

        def command_config
          @command_config ||= CommandConfig.new(inputs)
        end
      end
    end
  end
end
