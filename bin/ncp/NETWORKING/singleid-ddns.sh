#!/bin/bash

install()
{
  apt-get update
  apt-get install --no-install-recommends -y dnsutils
}

configure() 
{
  local updateurl=http://tun.dev.singleid.jp/box/forwarding/ddns

  [[ $ACTIVE != "yes" ]] && { 
    rm -f /etc/cron.d/singleid-ddns
    service cron restart
    echo "SingleID DDNS client is disabled"
    return 0
  }

  cat > /usr/local/bin/singleid-ddns.sh <<EOF
#!/bin/bash
echo "SingleID DDNS client started"
registeredIP=\$(dig +noedns +short "$FULLDOMAIN"|tail -n1)
currentIP=\$(dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed 's|"||g')
[ "\$currentIP" != "\$registeredIP" ] && {
  curl -s -X "POST" \
  "${updateurl}" \
  -H "accept: application/json" \
  -H "Authorization: token ${APIKEY}" \
  -d ""
}
echo "Registered IP: \$registeredIP | Current IP: \$currentIP"
EOF
  chmod 744 /usr/local/bin/singleid-ddns.sh

  echo "*/${UPDATEINTERVAL}  *  *  *  *  root  /bin/bash /usr/local/bin/singleid-ddns.sh" > /etc/cron.d/singleid-ddns
  chmod 644 /etc/cron.d/singleid-ddns
  service cron restart

  set-nc-domain "${FULLDOMAIN}"

  echo "SingleID DDNS client is enabled"
}

# License
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA
