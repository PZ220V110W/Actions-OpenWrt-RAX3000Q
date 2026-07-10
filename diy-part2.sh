#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# ============================================================
# Fix: Prevent netifd from forcefully writing ap_isolate=1
# ============================================================
# When multicast_to_unicast is not explicitly disabled on br-lan,
# netifd forces ap_isolate=1 in hostapd config regardless of the
# wireless setting, causing intra-BSS client isolation.
# See: https://github.com/openwrt/openwrt/issues/8159
# ============================================================
mkdir -p files/etc/config
cat >> files/etc/config/network << "EOF"

config device
    option name 'br-lan'
    option type 'bridge'
    option multicast_to_unicast '0'
EOF
