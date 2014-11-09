describe "dimus-dns::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  before do
  end

  it "does include maradns" do
    expect(chef_run).to include_recipe "maradns"
  end

end
