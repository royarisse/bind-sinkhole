#!/usr/bin/env bash

set -e

function installCron() {
  cp cron /etc/cron.daily/bind-sinkhole
  chmod +x /etc/cron.daily/bind-sinkhole
}

function installFiles() {
  cp hosts.allow /etc/bind/hosts.allow
  cp hosts.block /etc/bind/hosts.block
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