require_relative "version"

Gem::Specification.new do |spec|
  spec.name = "foobara-typescript-react-command-form-generator"
  spec.version = Foobara::Generators::TypescriptReactCommandFormGenerator::VERSION
  spec.authors = ["Miles Georgi"]
  spec.email = ["azimux@gmail.com"]

  spec.summary = "Generates Typescript React forms for Foobara remote commands"
  spec.homepage = "https://github.com/foobara/generators-typescript-react-command-form-generator"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.add_dependency "foobara"
  spec.add_dependency "foobara-files-generator"
  spec.add_dependency "foobara-typescript-remote-command-generator"

  spec.files = Dir[
    "lib/**/*",
    "src/**/*",
    "LICENSE.txt"
  ]

  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"
end
