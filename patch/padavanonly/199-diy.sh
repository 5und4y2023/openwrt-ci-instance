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
FRPMAC_CLEAN=$(echo "$FRPMAC" | tr -d ':' | tr 'a-f' 'A-F')

# 5. 组合成FRPNAME
FRPNAME="${FRPMAC_CLEAN}"


#echo "处理后MAC: $FRPMAC_CLEAN"
#echo "最终FRPNAME: $FRPNAME"

uci set frpc.common.server_addr='frp.jcmeng.top'
uci set frpc.common.server_port='40101'
uci set frpc.common.token='frp2026+-*.'
uci set frpc.common.tls_enable='false'

uci set frpc.common.admin_addr='127.0.0.1'
uci set frpc.common.admin_port='19698'
uci set frpc.common.admin_user='frpc'
uci set frpc.common.admin_pwd='1234qwer+-'

uci add frpc conf
uci set frpc.@conf[-1].name="${FRPNAME}_luci"
uci set frpc.@conf[-1].type='tcp'
uci set frpc.@conf[-1].use_encryption='true'
uci set frpc.@conf[-1].use_compression='true'
uci set frpc.@conf[-1].local_ip='127.0.0.1'
uci set frpc.@conf[-1].local_port='80'
uci set frpc.@conf[-1].remote_port='0'

uci add frpc conf
uci set frpc.@conf[-1].name="${FRPNAME}_clash"
uci set frpc.@conf[-1].type='tcp'
uci set frpc.@conf[-1].use_encryption='true'
uci set frpc.@conf[-1].use_compression='true'
uci set frpc.@conf[-1].local_ip='127.0.0.1'
uci set frpc.@conf[-1].local_port='9090'
uci set frpc.@conf[-1].remote_port='0'

uci add frpc conf
uci set frpc.@conf[-1].name="${FRPNAME}_frpweb"
uci set frpc.@conf[-1].type='tcp'
uci set frpc.@conf[-1].use_encryption='true'
uci set frpc.@conf[-1].use_compression='true'
uci set frpc.@conf[-1].local_ip='127.0.0.1'
uci set frpc.@conf[-1].local_port='19698'
uci set frpc.@conf[-1].remote_port='0'

uci commit
/etc/init.d/frpc restart

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

#uci set luci.main.mediaurlbase=/luci-static/argon
#uci commit luci

#uci set network.lan.ipaddr='192.168.6.1'
uci set network.lan.ip6assign=64
uci del network.globals.ula_prefix
uci set dhcp.lan.dns_service='0'
uci del dhcp.lan.dhcpv6
uci del dhcp.lan.ndp
uci set dhcp.lan.ra='server'
uci del dhcp.lan.ra_flags
uci add_list dhcp.lan.ra_flags='none'
uci set network.lan.delegate='0'
uci set network.lan.ip6ifaceid='random'

uci commit dhcp
uci commit network
uci commit

#uci set wireless.default_MT7981_1_1.ssid=xiaoguo
#uci set wireless.default_MT7981_1_1.encryption=psk2+ccmp
#uci set wireless.default_MT7981_1_1.key=a11223344.

#uci set wireless.default_MT7981_1_2.ssid=TK888
#uci set wireless.default_MT7981_1_2.encryption=psk2+ccmp
#uci set wireless.default_MT7981_1_2.key=a11223344.
#uci commit wireless

uci commit

sed -i '/passwall/d' /etc/opkg/distfeeds.conf
sed -i '/Modem/d' /etc/opkg/distfeeds.conf
sed -ri '/check_signature/s@^[^#]@#&@' /etc/opkg.conf
sed -i '/filogic/d' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_core https://mirrors.vsean.net/openwrt/releases/24.10-SNAPSHOT/targets/mediatek/filogic/packages' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_kmods https://mirrors.vsean.net/openwrt/releases/24.10-SNAPSHOT/targets/mediatek/filogic/kmods/6.6.95-1-3ca4b8cb2fcc3a2027e8496143a86cab' /etc/opkg/distfeeds.conf
#sed -i '$a #src/gz kiddin9 https://dl.openwrt.ai/packages-24.10/aarch64_generic/kiddin9' /etc/opkg/customfeeds.conf

#sed -i 's/root::0:0:99999:7:::/root:$1$0kv2aZ4P$WkI.7M.V1N6WSEDahJwot.:0:0:99999:7:::/g' /etc/shadow
#sed -i 's/root:::0:99999:7:::/root:$1$0kv2aZ4P$WkI.7M.V1N6WSEDahJwot.:0:0:99999:7:::/g' /etc/shadow

/etc/init.d/network restart
/etc/init.d/odhcpd restart
/etc/init.d/rpcd restart

exit 0
