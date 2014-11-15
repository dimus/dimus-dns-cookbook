dimus-dns Cookbook
==================
Configures simple internal DNS with one master

[![Cookbook version][1]][2]
[![Continuous Integration Status][3]][4]


Requirements
------------

#### packages
- `bind9` - for installing name service

Usage
-----
#### dimus-dns::default
Just include `dimus-dns` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[dimus-dns]"
  ]
}
```
You need data bag dimus-dns/config.json
```json
{
  "id": "config",
  "zone_transfer_acl": "",
  "recursive_acl": "",
  "zones": [
    {
      "zone": "vagrantup.com",
      "SOA": "default-ubuntu-1204.vagrantup.com.",
      "email": "hostmaster@vagrantup.com.",
      "serial": "/serial",
      "refresh": 1200,
      "retry": 180,
      "expire": 2419200,
      "minimum": 1800,
      "ns": [
        {
          "zone": "vagrantup.com.",
          "nameserver": "default-ubuntu-1204.vagrantup.com."
        } ],
      "A": {
        "something.vagrantup.com.": "10.0.0.111"
      },
      "CNAME": {
        "something.vagrantup.com.": "everything.vagrantup.com."
      }
    }
  ]
}
```

License and Authors
-------------------
Authors: Dmitry Mozzherin

[1]: http://img.shields.io/cookbook/v/dimus/dimus-dns-cookbook.svg
[2]: https://github.com/dimus/dimus-dns-cookbook
[3]: http://img.shields.io/travis/dimus/dimus-dns-cookbook.svg
[4]: http://travis-ci.org/dimus/dimus-dns-cookbook
