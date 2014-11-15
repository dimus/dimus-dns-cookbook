def dns_config
  if node["dimus-dns"] && node["dimus-dns"]["config"]
    node["dimus-dns"]["config"]
  else
    data_bag_item("dimus-dns", "config")
  end
end

def dns_hosts
  if Chef::Config["solo"]
    []
  else
    traverse_nodes
  end
end

def traverse_nodes
  search("node", "*:*").each_with_object({}) do |n, hsh|
    begin
      n.domain
    rescue NoMethodError
      next
    end
    record = [n.fqdn + ".", n.ipaddress]
    add_host(hsh, n, record)
    add_reverse_host(hsh, n, record)
  end.sort
end

def add_host(res, n, record)
  res[n.domain] ? res[n.domain] << record : res[n.domain] = [record]
end

def add_reverse_host(res, n, record)
  reverse = n.ipaddress.split(".")[0..-2].reverse.join(".") + ".in-addr.arpa"
  res[reverse] ? res[reverse] << record : res[reverse] = [record]
end

include_recipe "apt"

%w(bind9 bind9utils bind9-doc).each do |pkg|
  package pkg
end

service "bind9" do
  provider Chef::Provider::Service::Init
  action :start
  not_if "ps ax | grep named"
end

dns = dns_config
hosts = dns_hosts

directory "/etc/bind/zones" do
  user "root"
  owner "root"
end

template "/etc/bind/named.conf.options" do
  source "named.conf.options"
  variables dns: dns
end

template "/etc/bind/named.conf.local" do
  source "named.conf.local"
  variables dns: dns
end

dns["zones"].each do |zone|
  src = format("zone_%s", zone["direction"])
  template format("/etc/bind/zones/%s", zone["file"]) do
    source src
    variables zone: zone, hosts: (hosts[zone["name"]] || [])
    notifies :restart, "service[bind9]"
  end
end
