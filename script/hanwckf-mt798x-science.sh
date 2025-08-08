sed -i 's/192.168.1.1/192.168.23.1/g' package/base-files/files/bin/config_generate
sed -i "s/192\.168\.[0-9]*\.[0-9]*/192.168.23.1/g" $(find ./feeds/luci/modules/luci-mod-system/ -type f -name "flash.js")
sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate
sed -i "s/ImmortalWrt/OpenWrt/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
mv $GITHUB_WORKSPACE/patch/banner package/base-files/files/etc/banner
# mv $GITHUB_WORKSPACE/patch/hanwckf/mt7986a-netcore-n60pro.dts target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7986a-netcore-n60.dts


#mv $GITHUB_WORKSPACE/patch/hanwckf/mtwifi.sh package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
mv $GITHUB_WORKSPACE/patch/hanwckf/199-diy-mini.sh package/base-files/files/etc/uci-defaults/zz-diy.sh

#完全删除luci版本
sed -i "s/+ ' \/ ' : '') + (luciversion ||/:/g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
#添加编译日期
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/usr/lib/os-release
sed -i "s/%C/\/ Complied on $(date +"%Y.%m.%d")/g" package/base-files/files/etc/openwrt_release
#mv $GITHUB_WORKSPACE/patch/hanwckf/xm-10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

#定制版补丁
mv $GITHUB_WORKSPACE/patch/tiktok/hanwckf-mtwifi.sh package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
mv $GITHUB_WORKSPACE/patch/tiktok/1-bgp.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
mv $GITHUB_WORKSPACE/patch/tiktok/10_system.js feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

#改大闪存
#sed -i 's/reg = <0x600000 0x6e00000>/reg = <0x600000 0x1ea00000>/' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7986a-xiaomi-redmi-router-ax6000.dts
#sed -i 's/<0x580000 0x7200000>/<0x580000 0xee00000>/g' target/linux/mediatek/files-5.4/arch/arm64/boot/dts/mediatek/mt7981-cmcc-rax3000m.dts
#sed -i 's/116736k/240128k/g' target/linux/mediatek/image/mt7981.mk


#下载5g模块
#git clone --depth=1 https://github.com/Siriling/5G-Modem-Support.git package/5g-modem
#sed -i 's/移动通信模组/通信模组/g' package/5g-modem/luci-app-modem/po/zh-cn/modem.po
#sed -i 's/移动通信模组/通信模组/g' package/5g-modem/luci-app-modem/po/zh_Hans/modem.po

# 添加kenzok8_small插件库, 编译新版Sing-box和hysteria，需golang版本1.20或者以上版本 ，可以用以下命令
rm -rf feeds/packages/lang/golang
git clone --depth 1 https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

rm -rf feeds/packages/net/{mosdns,v2ray-geodata}
rm -rf feeds/luci/applications/{luci-app-openclash,luci-app-passwall,luci-app-ssr-plus,luci-app-mosdns}
#find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
#find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone --depth 1 https://github.com/vernesong/OpenClash.git  package/openclash
# git clone --depth 1 https://github.com/fw876/helloworld.git package/helloworld
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall.git package/luci-app-passwall
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2.git package/luci-app-passwall2
#mv $GITHUB_WORKSPACE/patch/Makefile package/passwall-packages/xray-core/Makefile

#新版ssr-libev和ss-rust缺少依赖，所以延用旧版，删除新版
#rm -rf package/passwall-packages/shadowsocks-rust
#rm -rf package/passwall-packages/shadowsocksr-libev
#rm -rf package/helloworld/shadowsocks-rust
#rm -rf package/helloworld/shadowsocksr-libev

#git clone --depth=1 https://github.com/gdy666/luci-app-lucky.git package/luci-app-lucky
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/oaf
git clone --depth 1 https://github.com/sirpdboy/luci-app-netspeedtest.git package/luci-app-netspeedtest

rm -rf feeds/packages/net/{adguardhome,smartdns,tailscale}
rm -rf feeds/luci/applications/{luci-app-alist,luci-app-smartdns}
git clone --depth 1 https://github.com/kenzok8/small-package.git package/small-package
mv package/small-package/luci-app-adguardhome package/luci-app-adguardhome
mv package/small-package/adguardhome feeds/packages/net/adguardhome
mv package/small-package/luci-app-easymesh package/luci-app-easymesh
mv package/small-package/luci-app-gecoosac package/luci-app-gecoosac
mv package/small-package/luci-app-smartdns package/luci-app-tailscale
mv package/small-package/smartdns feeds/packages/net/tailscale
mv package/small-package/luci-app-smartdns package/luci-app-smartdns
mv package/small-package/smartdns feeds/packages/net/smartdns
mv package/small-package/luci-app-ikoolproxy package/luci-app-ikoolproxy
rm -rf package/small-package

git clone --depth 1 https://github.com/mingxiaoyu/luci-app-phtunnel.git package/phtunnel

# iStore
#git clone --depth 1 https://github.com/xiangfeidexiaohuo/extra-ipk.git package/extra-ipk
#mv package/extra-ipk/linkease package/linkease
#rm -rf package/extra-ipk

rm -rf feeds/packages/net/frp
git clone --depth 1 -b openwrt-24.10 https://github.com/immortalwrt/packages package/imm24pkg
mv package/imm24pkg/net/frp package/frp
rm -rf package/imm24pkg

rm -rf feeds/luci/applications/luci-app-frpc
git clone --depth 1 -b openwrt-24.10 https://github.com/immortalwrt/luci package/imm24luci
mv package/imm24luci/applications/luci-app-frpc package/luci-app-frpc
rm -rf package/imm24luci

#git clone --depth 1 https://github.com/coolsnowwolf/lede.git package/lede
#mv package/lede/package/lean/luci-app-leigod-acc package/luci-app-leigod-acc
#mv package/lede/package/lean/leigod-acc package/leigod-acc
#rm -rf package/lede
