#!/bin/bash
# SingleID Boxの設定

APTINSTALL="apt-get install -y --no-install-recommends"

install()
{
# nanopiのRSTボタンの設定
  apt-get update
  $APTINSTALL triggerhappy
  sed -i 's/--user nobody/--user root/g' /etc/systemd/system/multi-user.target.wants/triggerhappy.service
  cat > /etc/triggerhappy/triggers.d/nanopi.conf <<'EOF'
BTN_1 1 /sbin/reboot
EOF
  systemctl daemon-reload
  systemctl enable triggerhappy
  systemctl start triggerhappy
}

configure() { :; }


