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

dns = data_bag_item("dimus-dns", "config")

template "/etc/maradns/mararc" do
  source "mararc.erb"
  mode 0644
  owner "root"
  group "root"
  variables dns: dns
  notifies :restart, "service[maradns]"
end

if Chef::Config[:solo]
  msg = "dimus-dns::default uses search feture, it is"\
        "it is icompatible with Chef Solo"
  log msg do
    level :warn
  end
else
  hosts = search("node", "*:*")
  domains = {}
  hosts.each do |host|
    next if host.domain.to_s == ""
    record = { host.fqdn => host.ipaddress }
    log "ADDING DNS RECORD: #{host.fqdn}: #{host.ipaddress}"
    if domains[host.domain]
      domains[host.domain] << record
    else
      domains[host.domain] = [record]
    end
  end

  # zones.each loop
  dns["zones"].each do |zone|
    template "/etc/maradns/db." + zone["zone"] do
      source "zone.erb"
      variables zone: zone, domain: domains[zone["zone"]]
      mode 0644
      owner "root"
      group "root"
      notifies :restart, "service[maradns]"
    end
  end
end
