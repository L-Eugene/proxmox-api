# proxmox-api
[![Build Status](https://travis-ci.com/L-Eugene/proxmox-api.svg?branch=master)](https://travis-ci.com/L-Eugene/proxmox-api)

## What is it?
ProxmoxAPI is Ruby wrapper for [Proxmox REST API](https://pve.proxmox.com/pve-docs/api-viewer/index.html). 
It simply send your requests to Proxmox REST API server without verifying them. 

## Usage

### Installation

You can add this gem to your Gemfile and use bundler:
```ruby
gem 'proxmox-api'
```

Or install gem manually:
```bash
gem install proxmox
```
### Authorization

Creating connection is as simple as giving all needed info to ProxmoxAPI constructor:

```ruby
require 'proxmox_api'

client = ProxmoxAPI.new(
  'proxmox-host.example.org',
  username: 'root', password: 'password', realm: 'pam', verify_ssl: false
)
``` 

First parameter is node we are going to connect to.
Second parameter is options hash. Possible options are: 
1. Ticket creation options **:username**, **:password**, **:realm**, **:otp**
   (see [/access/ticket](https://pve.proxmox.com/pve-docs/api-viewer/index.html#/access/ticket) request description)
    
1. SSL options, supported by [rest-client](https://github.com/rest-client/rest-client).
   See it's documentation for full list.

ProxmoxAPI constructor will automatically try to get access ticket with given credentials
and will raise an exception if this will fail.    

### Making requests

To build REST API url just chain it to client object. 
Calling **.get**, **.put**, **.post** or **.delete** will result in sending
appropriate request to Proxmox node. 

ProxmoxAPI::ApiException will be raised if server will return error status code.

```ruby
# Get current status of container with id 101 on pve1 node
client.nodes['pve1'].lxc[101].status.current.get

# Same request. You can use brackets or methods in any valid combination.
client.nodes.pve1.lxc[101].status[:current].get

# Same request again. Full api path can be given with brackets too.
client['nodes/pve1/lxc/101/status/current'].get

# Create user 'user' with password 'password' in 'pve' realm
client.access.users.post(userid: 'user@pve', password: 'password')

# Give user PVEAdmin role on server with vmid 101 
proxmox.access.acl.put(path: 'vms/101', users: 'user@pve', roles: 'PVEAdmin')
```

If you want to ignore server status codes, you can use dangerous methods:
```ruby
# Here we use dangerous method to check if user exists
proxmox.access.users['user@pve'].get!.nil?
```

## Contributing

Feel free to create [issue](https://github.com/L-Eugene/proxmox-api/issues) 
or propose [pull request](https://github.com/L-Eugene/proxmox-api/pulls) on [GitHub](https://github.com/L-Eugene/proxmox-api).