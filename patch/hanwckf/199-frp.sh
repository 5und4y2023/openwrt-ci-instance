#!/bin/sh
# 提取MAC地址
# br-lan
FRPMAC=$(ip link show br-lan | awk '/link\/ether/ {print $2}')

if [ -z "$FRPMAC" ]; then
    FRPMAC=$(cat /sys/class/net/br-lan/address 2>/dev/null)
fi

# eth0 和 wan
if [ -z "$FRPMAC" ]; then
    FRPMAC=$(cat /sys/class/net/eth0/address 2>/dev/null)
fi
if [ -z "$FRPMAC" ]; then
    FRPMAC=$(ip link show wan | awk '/link\/ether/ {print $2}')
fi


# 如果还不行，尝试获取第一个有MAC地址的接口
if [ -z "$FRPMAC" ]; then
    for iface in /sys/class/net/*/address; do
        FRPMAC=$(cat "$iface" 2>/dev/null | grep -v "00:00:00:00:00:00" | head -1)
        [ -n "$FRPMAC" ] && break
    done
fi

# 4. 处理MAC地址：去掉冒号并转大写
FRPNAME=$(echo "$FRPMAC" | tr -d ':' | tr 'a-f' 'A-F')

uci del frpc.ssh
uci set frpc.common.server_addr='frp.jcmeng.top'
uci set frpc.common.server_port='40101'
uci set frpc.common.token='frp2026+-*.'
#uci set frpc.common.admin_addr='127.0.0.1'
#uci set frpc.common.admin_port='19698'
#uci set frpc.common.admin_user='frpc'
#uci set frpc.common.admin_pwd='1234qwer+-'

uci set frpc.${FRPNAME}_luci=conf
uci set frpc.${FRPNAME}_luci.type='tcp'
uci set frpc.${FRPNAME}_luci.use_encryption='true'
uci set frpc.${FRPNAME}_luci.use_compression='true'
uci set frpc.${FRPNAME}_luci.local_ip='127.0.0.1'
uci set frpc.${FRPNAME}_luci.local_port='80'
uci set frpc.${FRPNAME}_luci.remote_port='41816'

uci set frpc.${FRPNAME}_clash=conf
uci set frpc.${FRPNAME}_clash.type='tcp'
uci set frpc.${FRPNAME}_clash.use_encryption='true'
uci set frpc.${FRPNAME}_clash.use_compression='true'
uci set frpc.${FRPNAME}_clash.local_ip='127.0.0.1'
uci set frpc.${FRPNAME}_clash.local_port='9090'
uci set frpc.${FRPNAME}_clash.remote_port='42816'

#uci set frpc.${FRPNAME}_frpweb=conf
#uci set frpc.${FRPNAME}_frpweb.type='tcp'
#uci set frpc.${FRPNAME}_frpweb.use_encryption='true'
#uci set frpc.${FRPNAME}_frpweb.use_compression='true'
#uci set frpc.${FRPNAME}_frpweb.local_ip='127.0.0.1'
#uci set frpc.${FRPNAME}_frpweb.local_port='19698'
#uci set frpc.${FRPNAME}_frpweb.remote_port='43816'

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

#uci set network.wan.proto='pppoe'
#uci set network.wan.username='0592915392025'
#uci set network.wan.password='822684'
#uci set network.lan.ipaddr=192.168.5.1
uci commit dhcp
uci commit network
uci commit

sed -i 's/root::0:0:99999:7:::/root:$1$ZgX9VyJs$dsQOixMortE8uPxcY65MK0:0:0:99999:7:::/g' /etc/shadow
sed -i 's/root:::0:99999:7:::/root:$1$ZgX9VyJs$dsQOixMortE8uPxcY65MK0:0:0:99999:7:::/g' /etc/shadow




exit 0
