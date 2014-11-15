default["bind"]["acl-role"] = "internal-acl"
default["bind"]["masters"] = %w(node.ipaddress)
default["bind"]["ipv6_listen"] = true
default["bind"]["zones"]["attribute"] = %w(node.domain)
default["bind"]["options"] = [
  "check-names slave ignore;",
  "provide-ixfr yes;",
  "recursive-clients 10000;",
  "request-ixfr yes;",
  "allow-notify { acl-dns-masters; };",
  "allow-query { trusted-lan; localhost; };",
  "allow-query-cache { trusted-lan; localhost; };",
  "allow-recursion { trusted-lan; localhost; };",
  "allow-transfer { acl-dns-masters; };",
  "allow-update-forwarding { any; };"
]
