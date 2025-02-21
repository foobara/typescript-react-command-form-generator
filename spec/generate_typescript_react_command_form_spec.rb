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

    expect(result.keys).to eq(["forms/SomeOrg/Auth/CreateUserForm.tsx"])
  end

  context "when command involves models" do
    let(:command_name) { "NestedModels2::CreateNested" }

    it "contains base files" do
      expect(result.keys).to eq(["forms/NestedModels2/CreateNestedForm.tsx"])
    end
  end

  context "when generating forms for all commands" do
    it "can successfully generate forms for all commands" do
      raw_manifest["command"].each_key do |command_name|
        files_json = described_class.run!(raw_manifest:, command_name:)

        expect(files_json).to be_a(Hash)
        expect(files_json.size).to eq(1)
        expect(files_json.keys.first).to include(command_name.gsub("::", "/"))
        expect(files_json.values.first).to be_a(String)
      end
    end
  end

  context "when command_name is bad" do
    let(:command_name) { "BadCommandName" }

    it "gives a relevant error" do
      expect(outcome).to_not be_success
      expect(errors.size).to eq(1)
      expect(outcome.errors_hash["data.command_name.bad_command_name"][:context][:bad_name]).to eq(command_name)
    end
  end

  context "when using a different manifest" do
    let(:raw_manifest) { JSON.parse(File.read("spec/fixtures/answer-bot-manifest.json")) }
    let(:command_name) { "Foobara::Ai::AnswerBot::Ask" }

    it "is successful" do
      expect(outcome).to be_success
      expect(result.keys).to eq(["forms/Foobara/Ai/AnswerBot/AskForm.tsx"])
    end
  end
end
