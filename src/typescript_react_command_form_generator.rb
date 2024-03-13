module Foobara
  module Generators
    module TypescriptReactCommandFormGenerator
      module Generators
        class TypescriptReactCommandFormGenerator < Foobara::FilesGenerator
          class << self
            def manifest_to_generator_classes(manifest)
              case manifest
              when TypescriptReactCommandFormConfig
                [
                  Generators::TypescriptReactCommandFormGenerator
                ]
              else
                # :nocov:
                raise "Not sure how build a generator for a #{manifest}"
                # :nocov:
              end
            end
          end

          def template_path
            ["src", "typescript_react_command_form.rb.erb"]
          end

          def target_path
            *path, file = module_path.map { |part| Util.underscore(part) }

            file = "#{file}.rb"

            ["src", *path, file]
          end

          alias typescript_react_command_form_config relevant_manifest

          def templates_dir
            "#{__dir__}/../templates"
          end
        end
      end
    end
  end
end
