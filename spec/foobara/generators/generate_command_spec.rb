RSpec.describe Foobara::Generators::CommandGenerator::GenerateCommand do
  let(:command_name) { "SomeOrg::SomeDomain::SomeCommand" }

  let(:inputs) do
    {
      command_name:,
      description: "whatever"
    }
  end
  let(:command) { described_class.new(inputs) }
  let(:outcome) { command.run }
  let(:result) { outcome.result }

  it "generates a command" do
    expect(outcome).to be_success

    command_file = result["src/some_org/some_domain/some_command.rb"]
    expect(command_file).to include("module SomeOrg")
    expect(command_file).to include("module SomeDomain")
    expect(command_file).to include("class SomeCommand")
  end

  context "with all options" do
    let(:homepage_url) { "https://example.com" }
    let(:license) { "LGPL" }

    let(:inputs) do
      {
        command_name: "SomeCommand",
        description: "whatever",
        organization_name: "SomeOrg",
        domain_name: "SomeDomain",
        full_module_name: "SomeOrg::SomeDomain::SomeCommand"
      }
    end

    it "generates a command using the given options" do
      expect(outcome).to be_success

      command_file = result["src/some_org/some_domain/some_command.rb"]
      expect(command_file).to include("module SomeOrg")
      expect(command_file).to include("module SomeDomain")
      expect(command_file).to include("class SomeCommand")
    end
  end
end
