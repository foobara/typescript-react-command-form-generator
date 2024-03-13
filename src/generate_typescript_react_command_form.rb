require "pathname"

require_relative "typescript_react_command_form_config"

module Foobara
  module Generators
    module TypescriptReactCommandFormGenerator
      class GenerateTypescriptReactCommandForm < Foobara::Generators::Generate
        class MissingManifestError < RuntimeError; end

        possible_error MissingManifestError

        inputs TypescriptReactCommandFormConfig

        def execute
          add_initial_elements_to_generate

          each_element_to_generate do
            generate_element
          end

          paths_to_source_code
        end

        attr_accessor :manifest_data

        def base_generator
          Generators::TypescriptReactCommandFormGenerator
        end

        # TODO: delegate this to base_generator
        def templates_dir
          # TODO: implement this?
          # :nocov:
          "#{__dir__}/../templates"
          # :nocov:
        end

        def add_initial_elements_to_generate
          elements_to_generate << typescript_react_command_form_config
        end

        def typescript_react_command_form_config
          @typescript_react_command_form_config ||= TypescriptReactCommandFormConfig.new(inputs)
        end
      end
    end
  end
end
