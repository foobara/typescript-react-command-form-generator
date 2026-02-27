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

        possible_input_error :command_name, BadCommandNameError

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
        rescue Manifest::InvalidPath
          valid_keys = manifest_data["command"].keys.sort

          suffix = command_name

          unless suffix.start_with?("::")
            suffix = "::#{suffix}"
          end

          matching_command_names = valid_keys.select { |key| key.end_with?(suffix) }

          if matching_command_names.size == 1
            best_command_name = matching_command_names.first
            self.command_manifest = Manifest::Command.new(manifest_data, [:command, best_command_name])
          else
            message = "Invalid command name: #{command_name}. Expected one of #{valid_keys.join(", ")}"
            error = BadCommandNameError.new(
              message:,
              context: {
                bad_name: command_name,
                valid_names: valid_keys
              },
              path: [:command_name]
            )

            add_input_error(error)
            halt!
          end
        end

        def add_command_manifest_to_set_of_elements_to_generate
          elements_to_generate << command_manifest
        end

        # We don't need this behavior from WriteTypescriptToDisk so we removed its input,
        # but it will explode if we don't provide it to inherited code
        def auto_dirty_queries = nil
      end
    end
  end
end
