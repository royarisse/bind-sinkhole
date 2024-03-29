# Bind Sinkhole

Block ads, porn and tracking by generating a zones file which you can include 
in your bind9 config.

## Usage

Either manually copy the zones files into `/etc/bind` or run `bind-sinkhole` to
generate / update `/etc/bind/zones.blocked`.

Follow install steps below to setup a cronjob to update the `zones.blocked` 
file daily and reload bind9.

The cronjob does NOT change your `named.conf.local`, it only changes the 
zone files.

## Install

1. Clone repository into a folder on your server;
2. Run the `install.sh`, it will:
    - Install the cronjob to `/etc/cron.daily/bind-sinkhole`;
    - The cronjob generates `/etc/bind/zones.blocked`;
    - Copy other zones to `/etc/bind`.
3. Change your `named.conf.local` to include the zones file, for example:

```named.conf.local
options {
  forwarders {
    1.1.1.3;
    1.0.0.3;
    208.67.222.123;
    208.67.220.123;
  }

  forward only;
}

include "/etc/bind/zones.blocked";
```

### Alternative: Use views
Using views allows you to include specific zone files (and forwarders) based on
client IP. 

```named.conf.local
acl work {
  1.2.3.4;
}

# Filter everything distracting
view strict {
  match-clients {
    work;
  };

  include "/etc/bind/zones.rfc1918";
  include "/etc/bind/zones.blocked";
  include "/etc/bind/zones.distracting";
  include "/etc/bind/zones.ads";
  
  forwarders {
    1.1.1.3;
    1.0.0.3;
    208.67.222.123;
    208.67.220.123;
  };

  forward only;
};

# Default / fallback zone: free for all
view nofilter {
  include "/etc/bind/zones.rfc1918";
  include "/etc/bind/named.conf.default-zones";

  forwarders {
    1.1.1.1;
    1.0.0.1;
  };
};
```


## Installation

Install the `bind-sinkhole` script as a daily cronjob:

```bash
wget -O- https://raw.githubusercontent.com/royarisse/bind-sinkhole/master/bind-sinkhole --quiet | \
  sudo tee /etc/cron.daily/bind-sinkhole
sudo chmod 700 /etc/cron.daily/bind-sinkhole
```
