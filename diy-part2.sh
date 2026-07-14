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
#
# Using uci-defaults script (instead of files/etc/config/network)
# to ensure the setting survives first-boot init.
# ============================================================
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99-fix-br-lan << "UCIEOF"
uci set network.@device[0].multicast_to_unicast='0'
uci commit network
exit 0
UCIEOF

# ============================================================
# Fix: Enable intra-BSS forwarding in ath11k firmware
# ============================================================
# Copy the ath11k driver patch to the mac80211 patches directory,
# so it gets applied during kernel module compilation.
# The patch sends WMI_VDEV_PARAM_INTRA_BSS_FWD=1 to the wireless
# firmware, enabling client-to-client forwarding on the same BSS.
# ============================================================
mkdir -p package/kernel/mac80211/patches/all-ipq50xx
cp $GITHUB_WORKSPACE/990-ath11k-enable-intra-bss-fwd.patch \
   package/kernel/mac80211/patches/all-ipq50xx/

# ============================================================
# Tag the firmware version for easy identification
# ============================================================
# Create a marker file to distinguish our fixed firmware
# from the original. Check with: cat /etc/rax3000q-fix
# ============================================================
mkdir -p files/etc
echo "INTRA_BSS_FIX_20260711" > files/etc/rax3000q-fix
