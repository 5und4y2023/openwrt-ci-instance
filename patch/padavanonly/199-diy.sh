#!/bin/sh

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

#uci set luci.main.mediaurlbase=/luci-static/argon
#uci commit luci

# uci set network.lan.ipaddr='192.168.0.1'
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
sed -i 's#downloads.immortalwrt.org#mirrors.pku.edu.cn/immortalwrt#g' /etc/opkg/distfeeds.conf
sed -i '/filogic/d' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_core https://mirrors.pku.edu.cn/immortalwrt/releases/24.10-SNAPSHOT/targets/mediatek/filogic/packages' /etc/opkg/distfeeds.conf
sed -i '$a src/gz openwrt_kmods https://mirrors.pku.edu.cn/immortalwrt/releases/24.10-SNAPSHOT/targets/mediatek/filogic/kmods/6.6.95-1-3ca4b8cb2fcc3a2027e8496143a86cab' /etc/opkg/distfeeds.conf
#sed -i '$a #src/gz kiddin9 https://dl.openwrt.ai/packages-24.10/aarch64_generic/kiddin9' /etc/opkg/customfeeds.conf

#sed -i 's/root::0:0:99999:7:::/root:$1$0kv2aZ4P$WkI.7M.V1N6WSEDahJwot.:0:0:99999:7:::/g' /etc/shadow
#sed -i 's/root:::0:99999:7:::/root:$1$0kv2aZ4P$WkI.7M.V1N6WSEDahJwot.:0:0:99999:7:::/g' /etc/shadow

cp /etc/my-clash /etc/openclash/core/clash_meta

/etc/init.d/network restart
/etc/init.d/odhcpd restart

exit 0
