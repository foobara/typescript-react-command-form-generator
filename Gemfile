require_relative "version"

source "https://rubygems.org"
ruby Foobara::Generators::TypescriptReactCommandFormGenerator::MINIMUM_RUBY_VERSION

gemspec

gem "rake"

# gem "foobara", path: "../foobara"
# gem "foobara-typescript-remote-command-generator", path: "../typescript-remote-command-generator"

group :development do
  gem "foobara-rubocop-rules"
  gem "guard-rspec"
  gem "rubocop-rake"
  gem "rubocop-rspec"
end

group :development, :test do
  gem "pry"
  gem "pry-byebug"
end

group :test do
  gem "foobara-spec-helpers"
  gem "rspec"
  gem "rspec-its"
  gem "simplecov"
end
