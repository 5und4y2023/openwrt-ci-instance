#!/bin/sh

uci del frpc.ssh
uci set frpc.common.server_addr='frp.jcmeng.top'
uci set frpc.common.server_port='40101'
uci set frpc.common.token='frp2026+-*.'
uci set frpc.common.admin_addr='127.0.0.1'
uci set frpc.common.admin_port='19698'
uci set frpc.common.admin_user='frpc'
uci set frpc.common.admin_pwd='1234qwer+-'

uci set frpc.${FRPNAME}_luci=conf
uci set frpc.${FRPNAME}_luci.type='tcp'
uci set frpc.${FRPNAME}_luci.use_encryption='true'
uci set frpc.${FRPNAME}_luci.use_compression='true'
uci set frpc.${FRPNAME}_luci.local_ip='127.0.0.1'
uci set frpc.${FRPNAME}_luci.local_port='80'
uci set frpc.${FRPNAME}_luci.remote_port='0'

uci set frpc.${FRPNAME}_clash=conf
uci set frpc.${FRPNAME}_clash.type='tcp'
uci set frpc.${FRPNAME}_clash.use_encryption='true'
uci set frpc.${FRPNAME}_clash.use_compression='true'
uci set frpc.${FRPNAME}_clash.local_ip='127.0.0.1'
uci set frpc.${FRPNAME}_clash.local_port='9090'
uci set frpc.${FRPNAME}_clash.remote_port='0'

uci set frpc.${FRPNAME}_frpweb=conf
uci set frpc.${FRPNAME}_frpweb.type='tcp'
uci set frpc.${FRPNAME}_frpweb.use_encryption='true'
uci set frpc.${FRPNAME}_frpweb.use_compression='true'
uci set frpc.${FRPNAME}_frpweb.local_ip='127.0.0.1'
uci set frpc.${FRPNAME}_frpweb.local_port='19698'
uci set frpc.${FRPNAME}_frpweb.remote_port='0'

uci commit
/etc/init.d/frpc restart

uci del dhcp.lan.ra
uci del dhcp.lan.ra_slaac
uci del dhcp.lan.dns_service
uci del dhcp.lan.ra_flags
uci del network.globals.ula_prefix
uci del dhcp.lan.dhcpv6
uci del dhcp.lan.ndp
uci del network.wan6
uci del network.lan.ip6assign

#uci set network.lan.ipaddr=192.168.5.1
uci commit dhcp
uci commit network


sed -i 's/root::0:0:99999:7:::/root:$1$ZgX9VyJs$dsQOixMortE8uPxcY65MK0:0:0:99999:7:::/g' /etc/shadow
sed -i 's/root:::0:99999:7:::/root:$1$ZgX9VyJs$dsQOixMortE8uPxcY65MK0:0:0:99999:7:::/g' /etc/shadow




exit 0
