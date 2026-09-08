#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 追加自定义内核配置项
echo "CONFIG_PSI=y
CONFIG_KPROBES=y
CONFIG_DEBUG_KERNEL=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_YT921X=y
CONFIG_NET_DSA_YT921X=y
CONFIG_R8125=y
CONFIG_R8126=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_VLAN_8021Q=y" >> target/linux/rockchip/armv8/config-6.6
cat target/linux/rockchip/armv8/config-6.6


# 集成CPU性能跑分脚本
cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-arm64 package/base-files/files/bin/coremark-arm64
cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-arm64.sh package/base-files/files/bin/coremark.sh
chmod 755 package/base-files/files/bin/coremark-arm64
chmod 755 package/base-files/files/bin/coremark.sh


# 复制dts设备树文件到指定目录下
cp -a $GITHUB_WORKSPACE/configfiles/dts/rk3588/* target/linux/rockchip/dts/rk3588/


# iStoreOS-settings
git clone --depth=1 -b main https://github.com/xiaomeng9597/istoreos-settings package/default-settings


# 定时限速插件
git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus package/luci-app-eqosplus



# 增加bdy_g98-nas
echo -e "\\ndefine Device/bdy_g98-nas
\$(call Device/Legacy/rk3588,\$(1))
  DEVICE_VENDOR := BDY
  DEVICE_MODEL := G98 NAS
  DEVICE_PACKAGES += kmod-r8169 kmod-nvme kmod-ata-ahci-dwc kmod-hwmon-pwmfan kmod-thermal
endef
TARGET_DEVICES += bdy_g98-nas" >> target/linux/rockchip/image/legacy.mk


# 复制配置文件到对应的目录下
cp -f $GITHUB_WORKSPACE/configfiles/init.sh target/linux/rockchip/armv8/base-files/lib/board/init.sh
cp -f $GITHUB_WORKSPACE/configfiles/02_network target/linux/rockchip/armv8/base-files/etc/board.d/02_network


cp -a $GITHUB_WORKSPACE/configfiles/driver/* target/linux/generic/files
ls target/linux/generic/files


cp -f $GITHUB_WORKSPACE/configfiles/driver/999-01-net-dsa-add-yt921x-header-defs.patch target/linux/rockchip/patches-6.6/999-01-net-dsa-add-yt921x-header-defs.patch


cp -f $GITHUB_WORKSPACE/configfiles/packages/204-01-disk-part_dos-reject-GPT-protective-MBR.patch package/boot/uboot-rockchip/patches/204-01-disk-part_dos-reject-GPT-protective-MBR.patch


sed -i '/for e in \$val; do json_add_string "" "\$e"; done/c\
\n\t\t\tlocal keys p seen=" "\
\t\t\tjson_get_keys keys\
\t\t\tfor k in $keys; do json_get_var p "$k"; seen="$seen$p "; done\
\t\t\tfor e in $val; do [ -n "${seen##* $e *}" ] && json_add_string "" "$e" && seen="$seen$e "; done\n' package/base-files/files/lib/functions/uci-defaults.sh
# cp -f $GITHUB_WORKSPACE/configfiles/uci-defaults.sh package/base-files/files/lib/functions/uci-defaults.sh


# cp -f $GITHUB_WORKSPACE/configfiles/netdevices.mk package/kernel/linux/modules/netdevices.mk


# cp -f $GITHUB_WORKSPACE/configfiles/driver/dsa/011-net-dsa-add-tag_yt921x-source.patch target/linux/rockchip/patches-6.6/011-net-dsa-add-tag_yt921x-source.patch
# cp -f $GITHUB_WORKSPACE/configfiles/driver/Makefile3 target/linux/rockchip/Makefile


# cp -f $GITHUB_WORKSPACE/configfiles/stmmac_main.c.txt stmmac_main.c.txt
# cp -f $GITHUB_WORKSPACE/configfiles/Makefile-dsa.txt target/linux/rockchip/Makefile
ls
