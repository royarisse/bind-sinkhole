# Bind Sinkhole

Block ads, porn and tracking by generating a zones file which you can include 
in your bind9 config.

## Usage

Simply tun the `bind-sinkhole` script and the `/etc/bind/zones.blocked` file 
will be generated.

## Setup

1. Create the `blocked.zone` file;
2. Core filtering relies on Cloudflare's Family DNS, see `resolvers` below;
3. Additional filtering uses`zones.blocked`, see `include` below.

```bash
wget -O- https://raw.githubusercontent.com/royarisse/bind-sinkhole/master/blocked.zone --quiet | \
 sed "s/example.com/$(hostname -f)/g" | sudo tee /etc/bind/blocked.zone

echo 'options {
  forwarders {
    1.1.1.3;
    1.0.0.3;
  }
}

include "/etc/bind/zones.blocked";' | sudo tee -a /etc/bind/named.conf.local
```

## Installation

Install the `bind-sinkhole` script as a daily cronjob:

```bash
wget -O- https://raw.githubusercontent.com/royarisse/bind-sinkhole/master/bind-sinkhole --quiet | \
  sudo tee /etc/cron.daily/bind-sinkhole
sudo chmod 700 /etc/cron.daily/bind-sinkhole
```
