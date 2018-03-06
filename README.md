# Authorized Networks

[![Build Status](https://travis-ci.org/adamcooke/authorized_networks.svg?branch=master)](https://travis-ci.org/adamcooke/authorized_networks) [![Gem Version](https://badge.fury.io/rb/authorized_networks.svg)](https://badge.fury.io/rb/authorized_networks)


This library is a very small wrapper to help identify whether a given IP address is part of an authorized network or not. It integrates with Rails applications to provide a `before_action` callback which can be used to block unauthorized requests.

## Installation

```ruby
gem 'authorized_networks'
```

## Configuration

You need to provide a list of authorized networks in the form a YAML file. By default, in a Rails application, it will look in `RAILS_ROOT/config/authorized_networks.yml` and for a non-Rails application it'll look in `/etc/authorized_networks.yml`.

The config file itself is split into groups which can be enabled or disabled. For example:

```yaml
default:
  - 127.0.0.1/32
  - 10.0.0.0/24
  - 2a00:67a0:abcd::/64

vpn:
  - 172.16.0.0/24

oob:
  - 10.2.44.12
```

In this file, there are two groups, the `default` group and the `vpn` group.

```ruby
AuthorizedNetworks.configure do |config|

  # Always include the vpn group when validating IPs are on the authorized network
  config.default_groups << :vpn

  # Change the path to the config file
  config.networks_file_path = "/some/other/path.yml"

end
```

## Usage

In the most basic form, you can simply use the `valid_ip?` method.

```ruby
# The most basic which will check in the default groups
AuthorizedNetworks.valid_ip?('1.2.3.4')

# Check in a list of groups
AuthorizedNetworks.valid_ip?('1.2.3.4', :groups => [:oob])

# Raise an error if there's an invalid IP
AuthorizedNetworks.valid_ip!('1.2.3.4')
```

### Usage in a Rails controller

You can easily verify that

```ruby
class AdminController < ApplicationController

  before_action :require_authorized_network

  rescue_from AuthorizedNetworks::UnauthorizedNetworkError, :with => :unauthorized_network_error

  private

  def unauthorized_network_error
    redirect_to root_path, :notice => "Your are not permitted to access this URL."
  end

end
```
