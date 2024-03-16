require_relative "generate_typescript_react_command_form"

module Foobara
  module Generators
    module TypescriptReactCommandFormGenerator
      class WriteTypescriptReactCommandFormToDisk < RemoteGenerator::WriteTypescriptToDisk
        class NoManifestError < Foobara::RuntimeError
          class << self
            def context_type_declaration
              {}
            end
          end
        end

        class << self
          def generator_key
            "typescript-react-command-form"
          end
        end

        inputs do
          raw_manifest :associative_array, :allow_nil
          manifest_url :string, :allow_nil
          command_name :string, :required
          output_directory :string
        end

        depends_on GenerateTypescriptReactCommandForm

        def execute
          load_manifest_if_needed
          generate_typescript
          write_all_files_to_disk
          run_post_generation_tasks

          stats
        end

        def validate
          # We don't want to fail if there is no manifest because we might be able to load it from manifest.json
        end

        def raw_manifest
          @raw_manifest || inputs[:raw_manifest]
        end

        def load_manifest_if_needed
          if !raw_manifest && !manifest_url
            manifest_path = "#{output_directory}/manifest.json"
            if File.exist?(manifest_path)
              @raw_manifest = JSON.parse(File.read(manifest_path))
            else
              message = "Because there is no manifest.json to read manifest from, " \
                        "you must either provide a manifest_url or raw_manifest."
              error = NoManifestError.new(message:, context: {})

              add_runtime_error(error)
            end
          end
        end

        def output_directory
          inputs[:output_directory] || default_output_directory
        end

        def default_output_directory
          # :nocov:
          "src/domains"
          # :nocov:
        end

        def generate_typescript
          # TODO: we need a way to allow values to be nil in type declarations
          inputs = raw_manifest ? { raw_manifest: } : { manifest_url: }
          inputs.merge!(command_name:)

          self.paths_to_source_code = run_subcommand!(GenerateTypescriptReactCommandForm, inputs)
        end

        def run_post_generation_tasks
          eslint_fix
        end
      end
    end
  end
end
