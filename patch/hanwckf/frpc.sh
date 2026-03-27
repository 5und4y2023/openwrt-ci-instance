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


#echo "处理后MAC: $FRPNAME"

uci del frpc.ssh
uci set frpc.common.server_addr='frp.jcmeng.top'
uci set frpc.common.server_port='40101'
uci set frpc.common.token='frp2026+-*.'
uci set frpc.common.admin_addr='127.0.0.1'
uci set frpc.common.admin_port='19698'
uci set frpc.common.admin_user='frpc'
uci set frpc.common.admin_pwd='1234qwer+-'

uci set frpc.$FRPNAME_luci=conf
uci set frpc.$FRPNAME_luci.type='tcp'
uci set frpc.$FRPNAME_luci.use_encryption='true'
uci set frpc.$FRPNAME_luci.use_compression='true'
uci set frpc.$FRPNAME_luci.local_ip='127.0.0.1'
uci set frpc.$FRPNAME_luci.local_port='80'
uci set frpc.$FRPNAME_luci.remote_port='0'

uci set frpc.$FRPNAME_clash=conf
uci set frpc.$FRPNAME_clash.type='tcp'
uci set frpc.$FRPNAME_clash.use_encryption='true'
uci set frpc.$FRPNAME_clash.use_compression='true'
uci set frpc.$FRPNAME_clash.local_ip='127.0.0.1'
uci set frpc.$FRPNAME_clash.local_port='9090'
uci set frpc.$FRPNAME_clash.remote_port='0'

uci set frpc.$FRPNAME_frpweb=conf
uci set frpc.$FRPNAME_frpweb.type='tcp'
uci set frpc.$FRPNAME_frpweb.use_encryption='true'
uci set frpc.$FRPNAME_frpweb.use_compression='true'
uci set frpc.$FRPNAME_frpweb.local_ip='127.0.0.1'
uci set frpc.$FRPNAME_frpweb.local_port='19698'
uci set frpc.$FRPNAME_frpweb.remote_port='0'

uci commit
/etc/init.d/frpc restart
exit 0
