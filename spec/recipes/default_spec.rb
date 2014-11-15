describe "dimus-dns::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  before do
    stub_data_bag_item("dimus-dns", "config").and_return("zones" => [])
    stub_command("ps ax | grep named").and_return(nil)
  end

  it "does include apt" do
    expect(chef_run).to include_recipe "apt"
  end

  it "installs bind9" do
    expect(chef_run).to install_package "bind9"
  end

  it "installs bind9utils" do
    expect(chef_run).to install_package "bind9utils"
  end

  it "installs bind9-doc" do
    expect(chef_run).to install_package "bind9-doc"
  end

  it "starts bind server" do
    expect(chef_run).to start_service "bind9"
  end

  it "creates dir /etc/bind/zones" do
    expect(chef_run).to create_directory "/etc/bind/zones"
  end

  it "creates template /etc/bind/named.conf.options" do
    expect(chef_run).to create_template "/etc/bind/named.conf.options"
  end

  it "creates template /etc/bind/named.conf.local" do
    expect(chef_run).to create_template "/etc/bind/named.conf.local"
  end
end
