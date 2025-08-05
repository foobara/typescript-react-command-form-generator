require "find"

require_relative "version"

Gem::Specification.new do |spec|
  spec.name = "foobara-typescript-react-command-form-generator"
  spec.version = Foobara::Generators::TypescriptReactCommandFormGenerator::VERSION
  spec.authors = ["Miles Georgi"]
  spec.email = ["azimux@gmail.com"]

  spec.summary = "Generates Typescript React forms for Foobara remote commands"
  spec.homepage = "https://github.com/foobara/generators-typescript-react-command-form-generator"

  # Equivalent to SPDX License Expression: Apache-2.0 OR MIT
  spec.license = "Apache-2.0 OR MIT"
  spec.licenses = ["Apache-2.0", "MIT"]

  spec.required_ruby_version = Foobara::Generators::TypescriptReactCommandFormGenerator::MINIMUM_RUBY_VERSION

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.add_dependency "foobara-typescript-remote-command-generator", "< 2.0.0"

  spec.files = Dir[
    "lib/**/*",
    "src/**/*",
    "LICENSE.txt",
    "README.md",
    "CHANGELOG.md"
    # NOTE: We can't just do "templates/**/*" because there can be hidden files/directories which are skipped
  ] + Find.find("templates/").select { |f| File.file?(f) }

  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"
end
