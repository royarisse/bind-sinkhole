#!/usr/bin/env bash

set -e

function installCron() {
  cp cron /etc/cron.daily/bind-sinkhole
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

function runCron() {
  /etc/cron.daily/bind-sinkhole
}

function main() {
    installFiles
    installCron
    runCron
}

main;