RSpec.describe Foobara::Generators::TypescriptReactCommandFormGenerator::GenerateTypescriptReactCommandForm do
  let(:command) { described_class.new(inputs) }
  let(:outcome) { command.run }
  let(:result) { outcome.result }
  let(:errors) { outcome.errors }
  let(:inputs) do
    {
      raw_manifest:,
      command_name:
    }
  end
  let(:raw_manifest_json) { File.read("spec/fixtures/foobara-manifest.json") }
  let(:raw_manifest) { JSON.parse(raw_manifest_json) }
  let(:command_name) { "SomeOrg::Auth::CreateUser" }

  it "contains base files" do
    expect(outcome).to be_success

    expect(result.keys).to include("forms/SomeOrg/Auth/CreateUser/CreateUserForm.tsx")
  end
end
