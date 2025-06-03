# Bind Sinkhole

Block ads, nsfw and tracking by generating a zones file which you can include
in your bind9 config.

## Install

1. Clone repository into a folder on your server;
2. Run the `install.sh`, it will:
    - Install the cronjob to `/etc/cron.daily/bind-sinkhole`;
    - Copy `/etc/bind/hosts.allow` and `/etc/bind/hosts.block`;
    - The cronjob generates `/etc/bind/zones.blocked`;
3. Change your `named.conf.local` to include the `zones.blocked`, for example:

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

## Usage

When installed, there will be two configuration files:

- `/etc/bind/hosts.allow`;
- `/etc/bind/hosts.block`.

These files can be changed, adding one domain or subdomain per line.
These files will then be used by the cronjob to generate the
`/etc/bind/zones.blocked` file. Optionally, you can run the cronjob manually
to update the zones file:

```bash
/etc/cron.daily/bind-sinkhole
```

### Alternative: Use views

Using views allows you to include specific zone files (and forwarders) based on
client IP. You can manually add extra `zones.*` files if you want to.

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
