#!/bin/bash
# SingleID Boxの設定

APTINSTALL="apt-get install -y --no-install-recommends"

install()
{
# nanopiのRSTボタンの設定
  apt-get update
  $APTINSTALL triggerhappy
  sed -i 's/--user nobody/--user root/g' /etc/systemd/system/multi-user.target.wants/triggerhappy.service
  echo 'BTN_1 1 /sbin/reboot' | sudo tee /etc/triggerhappy/triggers.d/nanopi.conf > /dev/null
  systemctl daemon-reload
  systemctl start triggerhappy
}

configure() { :; }


