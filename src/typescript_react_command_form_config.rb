require "English"

module Foobara
  module Generators
    module TypescriptReactCommandFormGenerator
      class TypescriptReactCommandFormConfig < Foobara::Model
        attributes do
          typescript_react_command_form_name :string, :required
          description :string, :allow_nil
        end

        attr_accessor :module_path

        def initialize(attributes = nil, options = {})
          typescript_react_command_form_name = attributes[:typescript_react_command_form_name]
          description = attributes[:description]

          module_path = typescript_react_command_form_name.split("::")

          super(
            {
              typescript_react_command_form_name:,
              description:
            },
            options
          )

          self.module_path = module_path
        end
      end
    end
  end
end
