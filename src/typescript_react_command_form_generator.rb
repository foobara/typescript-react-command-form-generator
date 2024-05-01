module Foobara
  module Generators
    module TypescriptReactCommandFormGenerator
      module Generators
        class TypescriptReactCommandFormGenerator < RemoteGenerator::Services::TypescriptFromManifestBaseGenerator
          class << self
            def manifest_to_generator_classes(manifest)
              case manifest
              when Manifest::Command
                [
                  Generators::TypescriptReactCommandFormGenerator
                ]
              else
                # :nocov:
                super
                # :nocov:
              end
            end
          end

          def template_path
            "CommandForm.tsx.erb"
          end

          def target_path
            *parts, command_name = scoped_full_path

            ["forms", *parts, "#{command_name}Form.tsx"]
          end

          def command_generator
            @command_generator ||= RemoteGenerator::Services::CommandGenerator.new(command_manifest)
          end

          def model_generators(type = inputs_type, initial = true)
            return @model_generators if defined?(@model_generators)

            generators = if type.entity?
                           generator_class = RemoteGenerator::Services::UnloadedEntityGenerator
                           [generator_class.new(type.to_entity)]
                         elsif type.model?
                           generator_class = RemoteGenerator::Services::AtomModelGenerator
                           [generator_class.new(type.to_model)]
                         elsif type.type.to_sym == :attributes
                           type.attribute_declarations.values.map do |attribute_declaration|
                             model_generators(attribute_declaration, false)
                           end.flatten.uniq
                         elsif type.is_a?(Manifest::Array)
                           if type.element_type
                             model_generators(type.element_type, false)
                           end
                         else
                           # TODO: handle tuples and associative arrays
                           []
                         end

            if initial
              @model_generators = generators
            end

            generators
          end

          def dependencies
            [model_generators, *model_generators.map(&:dependencies)].flatten.uniq
          end

          def dependencies_to_generate
            []
          end

          alias command_manifest relevant_manifest

          def templates_dir
            "#{__dir__}/../templates"
          end

          def inputs_class_name
            "#{command_name}Inputs"
          end

          def result_class_name
            "#{command_name}Result"
          end

          def error_class_name
            "#{command_name}Error"
          end

          def command_name_english
            Util.humanize(Util.underscore(command_name))
          end

          def non_colliding_inputs(type_declaration = inputs_type, result = [], path = [])
            if type_declaration.attributes?
              type_declaration.attribute_declarations.each_pair do |attribute_name, attribute_declaration|
                non_colliding_inputs(attribute_declaration, result, [*path, attribute_name])
              end
            elsif type_declaration.entity?
              # TODO: figure out how to not pass self here...
              result << FlattenedAttribute.new(self, path, type_declaration.to_type.primary_key_type)
            elsif type_declaration.model?
              non_colliding_inputs(type_declaration.to_type.attributes_type, result, path)
            elsif type_declaration.array?
              if type_declaration.element_type
                model_generators(type_declaration.element_type, false)
              end
            else
              result << FlattenedAttribute.new(self, path, type_declaration)
            end

            result
          end

          def populated_inputs_object
            result = {}

            non_colliding_inputs.each do |flattened_attribute|
              DataPath.set_value_at(result, flattened_attribute.name, flattened_attribute.path)
            rescue DataPath::BadPathError
              value = result
              parts = flattened_attribute.path[..-2]

              parts.each do |part|
                value = value[part] ||= {}
              end

              DataPath.set_value_at(result, flattened_attribute.name, flattened_attribute.path)
            end

            _to_ts_string(result)
          end

          # TODO: come up with a better name for this and its parameter
          def _to_ts_string(result, depth: 0)
            if result.is_a?(::Hash)
              output = "#{" " * depth}{\n"
              result.each_pair.with_index do |(key, value), index|
                output << "#{" " * depth}  #{key}: #{_to_ts_string(value, depth: depth + 2)}"

                if index != result.size - 1
                  output << ","
                end

                output << "\n"
              end

              "#{output}#{" " * depth}}\n"
            elsif result.is_a?(::String)
              result
            else
              # :nocov:
              raise "Not sure how to handle #{result}"
              # :nocov:
            end
          end

          class FlattenedAttribute
            attr_accessor :path, :type_declaration, :generator

            def initialize(generator, path, type_declaration)
              self.generator = generator
              self.path = path
              self.type_declaration = type_declaration
            end

            def name
              first, *rest = path

              first = Util.camelize(first)
              rest = rest.map { |part| Util.camelize(part) }

              [first, *rest].join
            end

            def name_upcase
              [name[0].upcase, name[1..]].compact.join
            end

            def ts_type
              generator.foobara_type_to_ts_type(
                type_declaration,
                dependency_group: generator.dependency_group
              )
            end

            def has_default?
              type_declaration.attribute? && default
            end

            def default
              type_declaration.default
            end

            def ts_default
              generator.value_to_ts_value(default)
            end

            def name_english
              Util.underscore(name).gsub("_", " ")
            end

            def html_input
              # TODO: handle boolean, etc
              one_of = type_declaration.one_of

              if one_of
                ts_type = generator.foobara_type_to_ts_type(type_declaration)

                "<select
                  value={#{name} ?? \"\"}
                  onChange={(e) => { set#{name_upcase}(e.target.value as #{ts_type}) }}
                >
                  #{one_of.map { |value| "<option value=\"#{value}\">#{value}</option>" }.join}
                </select>"
              else
                "<input
                    value={#{name} ?? \"\"}
                    onChange={(e) => { set#{name_upcase}(e.target.value) }}
                    placeholder=\"#{name_english}\"
                  />"
              end
            end
          end
        end
      end
    end
  end
end
