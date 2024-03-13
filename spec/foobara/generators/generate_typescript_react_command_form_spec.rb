RSpec.describe Foobara::Generators::TypescriptReactCommandFormGenerator::GenerateTypescriptReactCommandForm do
  let(:typescript_react_command_form_name) { "SomePrefix::SomeOrg" }

  let(:inputs) do
    {
      typescript_react_command_form_name:,
      description: "whatever"
    }
  end
  let(:typescript_react_command_form) { described_class.new(inputs) }
  let(:outcome) { typescript_react_command_form.run }
  let(:result) { outcome.result }

  it "generates a typescript_react_command_form" do
    expect(outcome).to be_success

    typescript_react_command_form_file = result["src/some_prefix/some_org.rb"]
    expect(typescript_react_command_form_file).to include("module SomeOrg")
    expect(typescript_react_command_form_file).to include("module SomePrefix")
  end
end
