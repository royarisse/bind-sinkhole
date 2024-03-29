#!/usr/bin/env bash

set -e

function installCron() {
  cp bind-sinkhole /etc/cron.daily/bind-sinkhole
  chmod +x /etc/cron.daily/bind-sinkhole
}

function installZones() {
  sed "s/example\.com\./$(hostname)/g" blocked.zone > /etc/bind/blocked.zone
  cp zones.* /etc/bind/
}

function runCron() {
  /etc/cron.daily/bind-sinkhole
}

function main() {
    installZones
    installCron
    runCron
}

main;