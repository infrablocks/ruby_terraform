require "spec_helper"

describe RubyTerraform do
  it "has a version number" do
    expect(RubyTerraform::VERSION).not_to be nil
  end

  it 'allows commands to be run without configure having been called' do
    allow(Open4).to(receive(:spawn))

    RubyTerraform.apply(directory: 'some/path/to/terraform/configuration')
  end
end
