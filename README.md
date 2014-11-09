dimus-dns Cookbook
==================
Creates a basic dns for private network

Requirements
------------

#### cookbooks
- `maradns` - for installing name service

Attributes
----------

#### dimus-dns::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['dimus-dns']['dns-servers']</tt></td>
    <td>Array</td>
    <td>list of external dns servers</td>
    <td><tt>[]</tt></td>
  </tr>
</table>

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

License and Authors
-------------------
Authors: Dmitry Mozzherin
