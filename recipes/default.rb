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
  nodes = search("node", "*:*")
  nodes.each_with_object({}) do |n, hsh|
    next unless (n.domain rescue nil)
    add_host(hsh, n)
  end
end

def add_host(res, n)
  record = [n.fqdn + ".", n.ipaddress]
  log "ADDING DNS RECORD: #{n.fqdn}: #{n.ipaddress}"
  res[n.domain] ? res[n.domain] << record : res[n.domain] = [record]
  reverse = n.ipaddress.split(".")[0..-2].reverse.join(".") + ".in-addr.arpa"
  log "DEBUG REVERSE " + reverse
  res[reverse] ? res[reverse] << record : res[reverse] = [record]
end

include_recipe "apt"

%w(bind9 bind9utils bind9-doc).each do |pkg|
  package pkg
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
  end
end
