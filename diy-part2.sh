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

# Fix 1: Prevent netifd from forcefully writing ap_isolate=1
mkdir -p files/etc/config
cat >> files/etc/config/network << "EOF"

config device
    option name 'br-lan'
    option type 'bridge'
    option multicast_to_unicast '0'
EOF

# Fix 2: Copy ath11k INTRA_BSS_FWD patch into build
mkdir -p package/kernel/mac80211/patches/all-ipq50xx
cp $GITHUB_WORKSPACE/990-ath11k-enable-intra-bss-fwd.patch \
   package/kernel/mac80211/patches/all-ipq50xx/

# Fix 3: Version marker — verify with: cat /etc/rax3000q-fix
mkdir -p files/etc
echo "INTRA_BSS_FIX_20260711" > files/etc/rax3000q-fix
