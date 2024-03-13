RSpec.describe Foobara::Generators::TypescriptReactCommandFormGenerator::WriteTypescriptReactCommandFormToDisk do
  let(:typescript_react_command_form) { described_class.new(inputs) }
  let(:outcome) { typescript_react_command_form.run }
  let(:result) { outcome.result }
  let(:errors) { outcome.errors }
  let(:inputs) do
    {
      typescript_react_command_form_config:,
      output_directory:
    }
  end
  let(:typescript_react_command_form_config) do
    {
      typescript_react_command_form_name:,
      description: "whatever"
    }
  end
  let(:typescript_react_command_form_name) { "SomeOrg" }
  let(:output_directory) { "#{__dir__}/../../../tmp/typescript_react_command_form_test_suite_output" }

  before do
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(described_class).to receive(:git_commit).and_return(nil)
    allow_any_instance_of(described_class).to receive(:rubocop_autocorrect).and_return(nil)
    # rubocop:enable RSpec/AnyInstance
    FileUtils.rm_rf output_directory
  end

  describe "#run" do
    it "contains base files" do
      expect(outcome).to be_success

      expect(typescript_react_command_form.paths_to_source_code.keys).to include("src/some_org.rb")
    end
  end

  describe "#output_directory" do
    context "with no output directory" do
      let(:inputs) do
        {
          typescript_react_command_form_config:
        }
      end

      it "writes files to the current directory" do
        typescript_react_command_form.cast_and_validate_inputs
        expect(typescript_react_command_form.output_directory).to eq(".")
      end
    end
  end

  describe ".generator_key" do
    subject { described_class.generator_key }

    it { is_expected.to be_a(String) }
  end
end
