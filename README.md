# Bind Sinkhole

Block ads, porn and tracking by generating a zones file which you can include 
in your bind9 config.

## Usage

Simply tun the `bind-sinkhole` script and the `/etc/bind/zones.blocked` file 
will be generated.

## Setup

1. Create the `blocked.zone` file;
2. Add the `zones.blocked` file to your `named.conf.local`:

```bash
wget -O- https://raw.githubusercontent.com/royarisse/bind-sinkhole/master/blocked.zone --quiet | \
 sed "/example.com/$(hostname)/g" | sudo tee /etc/bind/blocked.zone

echo 'include "/etc/bind/zones.blocked";' | sudo tee -a /etc/bind/named.conf.local
```

## Installation

Install the `bind-sinkhole` script as a daily cronjob:

```bash
wget -O- https://raw.githubusercontent.com/royarisse/bind-sinkhole/master/bind-sinkhole --quiet | sudo tee /etc/cron.daily/bind-sinkhole
sudo chmod 700 /etc/cron.daily/bind-sinkhole
```
