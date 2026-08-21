# Bind Sinkhole

Block ads, nsfw and tracking by generating a zones file which you can include
in your bind9 config.

## Install

1. Clone repository into a folder on your server;
2. Run the `install.sh`, it will:
    - Install the cronjob to `/etc/cron.daily/bind-sinkhole`;
    - Copy `/etc/bind/hosts.allow` and `/etc/bind/hosts.block`;
3. Change your `named.conf.local` to include the `rpz.blocked` zone, for example:

```named.conf.local
options {
  response-policy {
    zone "rpz.blocked";
  };

  forwarders {
    1.1.1.3;
    1.0.0.3;
    208.67.222.123;
    208.67.220.123;
  };

  forward only;
};

zone "rpz.blocked" {
  type master;
  file "/etc/bind/db.rpz.blocked";
};
```

## Usage

When installed, there will be two configuration files:

- `/etc/bind/hosts.allow`;
- `/etc/bind/hosts.block`.

These files can be changed, adding one domain or subdomain per line. These
files will then be used by the cronjob to generate the
`/etc/bind/db.rpz.blocked` file. Optionally, you can run the cronjob manually
to update the zones file:

```bash
/etc/cron.daily/bind-sinkhole
```

### Alternative: Use views

Using views allows you to include specific zone files (and forwarders) based on
client IP. You can manually add extra `zones.*` files if you want to.

```named.conf.local
# Filter everything distracting
view strict {
  match-clients {
    # Your home IP
    1.2.3.4;
  };

  include "/etc/bind/zones.rfc1918";

  zone "rpz.blocked" {
    type master;
    file "/etc/bind/db.rpz.blocked";
  };

  response-policy {
    zone "rpz.blocked";
  };

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
