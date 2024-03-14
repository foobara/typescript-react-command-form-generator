module Foobara
  module Generators
    module TypescriptReactCommandFormGenerator
      class GenerateTypescriptReactCommandForm < Foobara::RemoteGenerator::GenerateTypescript
        class BadCommandNameError < Value::DataError
          class << self
            def context_type_declaration
              {
                bad_name: :string,
                valid_names: [:string]
              }
            end
          end
        end

        possible_error BadCommandNameError

        inputs do
          raw_manifest :associative_array
          manifest_url :string
          command_name :string, :required
        end

        attr_accessor :manifest_data, :command_manifest

        def base_generator
          Generators::TypescriptReactCommandFormGenerator
        end

        def execute
          load_manifest_if_needed
          find_command_manifest
          add_command_manifest_to_set_of_elements_to_generate

          each_element_to_generate do
            generate_element
          end

          paths_to_source_code
        end

        def find_command_manifest
          self.command_manifest = Manifest::Command.new(manifest_data, [:command, command_name])
        rescue Manifest::InvalidPath => e
          valid_keys = manifest_data["command"].keys.sort
          message = "Invalid command name: #{command_name}. Expected one of #{valid_keys.join(", ")}"
          error = BadCommandNameError.new(message:,
                                          context: { bad_name: command_name,
                                                     valid_names: valid_keys })

          add_input_error(error)
          halt!
        end

        def add_command_manifest_to_set_of_elements_to_generate
          elements_to_generate << command_manifest
        end

        # TODO: delegate this to base_generator
        def templates_dir
          # TODO: implement this?
          "#{__dir__}/../templates"
        end
      end
    end
  end
end
