require "English"

module Foobara
  module Generators
    module CommandGenerator
      class CommandConfig < Foobara::Model
        attributes do
          command_name :string, :required
          description :string
          organization_name :string, :allow_nil
          domain_name :string, :allow_nil
          full_module_name :string
        end

        attr_accessor :module_path

        def initialize(attributes = nil, options = {})
          full_module_name = attributes[:full_module_name]
          module_path = full_module_name&.split("::")
          command_name = attributes[:command_name]
          description = attributes[:description]
          organization_name = attributes[:organization_name]
          domain_name = attributes[:domain_name]

          if organization_name.nil? && domain_name.nil? && full_module_name.nil?
            full_module_name = command_name
            module_path = full_module_name.split("::")

            *prefix, command_name = module_path

            *organization_parts, domain_name = prefix

            unless organization_parts.empty?
              organization_name = organization_parts.join("::")
            end
          end

          super(
            {
              command_name:,
              description:,
              organization_name:,
              domain_name:,
              full_module_name:
            },
            options
          )

          self.module_path = module_path
        end
      end
    end
  end
end
