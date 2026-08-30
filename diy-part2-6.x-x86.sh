#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

echo "CONFIG_PACKAGE_default-settings=y" >> .config


# 追加自定义内核配置项
echo "CONFIG_PSI=y
CONFIG_KPROBES=y" >> target/linux/x86/64/config-6.6


# 集成CPU性能跑分脚本
echo "CONFIG_PACKAGE_coremark=y" >> .config
cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-x86.sh package/base-files/files/bin/coremark.sh
chmod 755 package/base-files/files/bin/coremark.sh


# iStoreOS-settings
git clone --depth=1 -b main https://github.com/xiaomeng9597/istoreos-settings package/default-settings


# 定时限速插件
echo "CONFIG_PACKAGE_luci-app-eqosplus=y
CONFIG_PACKAGE_luci-i18n-eqosplus-zh-cn=y" >> .config
git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus package/luci-app-eqosplus
