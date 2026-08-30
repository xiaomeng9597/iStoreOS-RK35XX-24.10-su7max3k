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
