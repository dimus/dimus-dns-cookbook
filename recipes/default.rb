package "maradns" do
  action :upgrade
end

service "maradns" do
  action :enable
  supports(
    restart: true,
    status: false
  )
end

service "maradns-zoneserver" do
  action :enable
  supports restart: true
end

node_name = node.name
dns = data_bag_item("dimus-dns", "config")

if node_name == dns["primary"]
  source_file = "mararc-primary.erb"
end

template "/etc/maradns/mararc" do
  source "mararc.erb"
  mode 0644
  owner "root"
  group "root"
  variables dns: dns
  notifies :restart, resources(:service => "maradns")
end

hosts = search("node", "*:*")
domains = {}
hosts.each do |host|
  if node.respond_to?(:domain) && node.domain.to_s != ""
    record = { node.fqdn => node.ipaddress }
    if domains[node.domain]
      domains[node.domain] << record
    else
      domains[node.domain] = [record]
    end
  end
end

#zones.each loop
dns["zones"].each do |zone|
  template "/etc/maradns/db.#{zone["zone"]}" do
    source "zone.erb"
    variables :zone => zone, :domain => domains[zone["zone"]]
    mode 0644
    owner "root"
    group "root"
    notifies :restart, resources(:service => "maradns")
  end
end
