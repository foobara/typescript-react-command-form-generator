require_relative "generate_typescript_react_command_form"

module Foobara
  module Generators
    module TypescriptReactCommandFormGenerator
      class WriteTypescriptReactCommandFormToDisk < RemoteGenerator::WriteTypescriptToDisk
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
          generate_typescript
          write_all_files_to_disk
          run_post_generation_tasks

          stats
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
