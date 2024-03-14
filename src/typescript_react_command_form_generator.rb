module Foobara
  module Generators
    module TypescriptReactCommandFormGenerator
      module Generators
        class TypescriptReactCommandFormGenerator < Foobara::FilesGenerator
          class << self
            def manifest_to_generator_classes(manifest)
              case manifest
              when Manifest::Command
                [
                  Generators::TypescriptReactCommandFormGenerator
                ]
              else
                binding.pry
                # :nocov:
                raise "Not sure how build a generator for a #{manifest}"
                # :nocov:
              end
            end
          end

          def template_path
            "CommandForm.tsx.erb"
          end

          def command_generator
            @command_generator ||= RemoteGenerator::Services::CommandGenerator.new(command_manifest)
          end

          def target_path
            ["forms", *scoped_full_path, command_name]
          end

          alias command_manifest relevant_manifest

          def templates_dir
            "#{__dir__}/../templates"
          end
        end
      end
    end
  end
end
