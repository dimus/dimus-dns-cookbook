describe "dimus-dns::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  before do
    stub_data_bag_item("dimus-dns", "config").and_return({})
  end

  it "does include maradns" do
    expect(chef_run).to install_package "maradns"
  end

  it "enables service maradns" do
    expect(chef_run).to enable_service "maradns"
  end

  it "enables service maradns-zoneserver" do
    expect(chef_run).to enable_service "maradns-zoneserver"
  end

  it "creates template for mararc" do
    expect(chef_run).to create_template "/etc/maradns/mararc"
  end
end
