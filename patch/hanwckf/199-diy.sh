#!/bin/sh

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

uci set luci.main.lang='zh_cn'
uci commit

router_cpu=MT7981
uci set wireless.default_${router_cpu}_1_1.ssid=WiFi-${WIFINAME}-2.4G
uci set wireless.default_${router_cpu}_1_2.ssid=WiFi-${WIFINAME}-5G

uci set wireless.default_${router_cpu}_1_1.encryption=psk2+ccmp
uci set wireless.default_${router_cpu}_1_1.key=1234qwer+-
uci set wireless.${router_cpu}_1_1.htmode='HE20'
uci set wireless.default_${router_cpu}_1_2.encryption=psk2+ccmp
uci set wireless.default_${router_cpu}_1_2.key=1234qwer+-
uci set wireless.${router_cpu}_1_2.htmode='HE80'
uci set wireless.${router_cpu}_1_2.channel='44'
uci commit wireless

uci commit

#uci set network.lan.ipaddr=192.168.140.1
#uci commit dhcp
#uci commit network
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
