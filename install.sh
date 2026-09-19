#!/usr/bin/env bash

set -e

function installScript() {
  install -m 0755 sinkhole-update /usr/local/bin/sinkhole-update
}

function installCron() {
  cat > /etc/cron.daily/bind-sinkhole <<'EOF'
#!/usr/bin/env bash

/usr/local/bin/sinkhole-update > /dev/null
EOF

  chmod +x /etc/cron.daily/bind-sinkhole
}

function installFiles() {
  if [ ! -f /etc/bind/hosts.allow ]; then
    cp hosts.allow /etc/bind/hosts.allow
  fi

  if [ ! -f /etc/bind/hosts.block ]; then
    cp hosts.block /etc/bind/hosts.block
  fi
}

function runScript() {
  /usr/local/bin/sinkhole-update
}

function main() {
    installScript
    installFiles
    installCron
    runScript
}

main;