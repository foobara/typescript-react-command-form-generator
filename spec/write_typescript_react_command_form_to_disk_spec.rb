RSpec.describe Foobara::Generators::TypescriptReactCommandFormGenerator::WriteTypescriptReactCommandFormToDisk do
  let(:command) { described_class.new(inputs) }
  let(:outcome) { command.run }
  let(:result) { outcome.result }
  let(:errors) { outcome.errors }
  let(:inputs) do
    {
      raw_manifest:,
      output_directory:,
      command_name:
    }
  end
  let(:command_name) { "SomeOrg::Auth::CreateUser" }
  let(:output_directory) { "#{__dir__}/../tmp/domains" }
  let(:raw_manifest_json) { File.read("spec/fixtures/foobara-manifest.json") }
  let(:raw_manifest) { JSON.parse(raw_manifest_json) }

  it "contains base files" do
    expect(outcome).to be_success

    expect(
      command.paths_to_source_code["forms/SomeOrg/Auth/CreateUserForm.tsx"]
    ).to include("const [firstName, setFirstName] = useState<string | undefined>(undefined)")
  end

  context "without a manifest or url" do
    let(:raw_manifest) { nil }

    it "is not successful" do
      expect(outcome).to_not be_success
    end
  end
end
