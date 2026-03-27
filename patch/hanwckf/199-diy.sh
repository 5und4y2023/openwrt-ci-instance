#!/bin/sh

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

uci set luci.main.lang='zh_cn'
uci commit

uci del network.wan6
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

#uci set network.lan.ipaddr=192.168.140.1
uci commit dhcp
uci commit network
WIFINAME=$(ip link show br-lan 2>/dev/null | awk '/link\/ether/{split($2,m,":");print toupper(m[5]m[6])}')
uci set wireless.default_MT7986_1_1.ssid=WiFi-${WIFINAME}-2.4G
uci set wireless.default_MT7986_1_1.encryption=psk2+ccmp
uci set wireless.default_MT7986_1_1.key=1234qwer+-
uci set wireless.default_MT7986_1_2.ssid=WiFi-${WIFINAME}-5G
uci set wireless.default_MT7986_1_2.encryption=psk2+ccmp
uci set wireless.default_MT7986_1_2.key=1234qwer+-
uci commit wireless

uci commit

sed -i '/ssrp/d' /etc/opkg/distfeeds.conf
sed -i '/helloworld/d' /etc/opkg/distfeeds.conf
sed -i '/passwall/d' /etc/opkg/distfeeds.conf
sed -ri '/check_signature/s@^[^#]@#&@' /etc/opkg.conf
#sed -i 's/root::0:0:99999:7:::/root:$1$P.dQe2I4$BO.thcMA9OYlt8R8ECnnx1:0:0:99999:7:::/g' /etc/shadow
#sed -i 's/root:::0:99999:7:::/root:$1$P.dQe2I4$BO.thcMA9OYlt8R8ECnnx1:0:0:99999:7:::/g' /etc/shadow


/etc/init.d/network restart

exit 0
