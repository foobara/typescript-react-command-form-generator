RSpec.describe Foobara::Generators::OrganizationGenerator::GenerateOrganization do
  let(:organization_name) { "SomeOrg::SomeDomain::SomeOrganization" }

  let(:inputs) do
    {
      organization_name:,
      description: "whatever"
    }
  end
  let(:organization) { described_class.new(inputs) }
  let(:outcome) { organization.run }
  let(:result) { outcome.result }

  it "generates a organization" do
    expect(outcome).to be_success

    organization_file = result["src/some_org/some_domain/some_organization.rb"]
    expect(organization_file).to include("module SomeOrg")
    expect(organization_file).to include("module SomeDomain")
    expect(organization_file).to include("class SomeOrganization")
  end

  context "with all options" do
    let(:homepage_url) { "https://example.com" }
    let(:license) { "LGPL" }

    let(:inputs) do
      {
        organization_name: "SomeOrganization",
        description: "whatever",
        organization_name: "SomeOrg",
        domain_name: "SomeDomain",
        full_module_name: "SomeOrg::SomeDomain::SomeOrganization"
      }
    end

    it "generates a organization using the given options" do
      expect(outcome).to be_success

      organization_file = result["src/some_org/some_domain/some_organization.rb"]
      expect(organization_file).to include("module SomeOrg")
      expect(organization_file).to include("module SomeDomain")
      expect(organization_file).to include("class SomeOrganization")
    end
  end
end
