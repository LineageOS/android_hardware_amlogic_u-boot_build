# HardKernel ODROID-C4
collect FIP binaries:

./collect-c4_binaries-git-refboard.sh odroidg12-v2015.01 sm1 odroidc4

build u-boot:
./build.sh android-tv-10.0.0_r1 g12a_odroidc4_v1

generate fip binary:
./generate-bins-new.sh fip-collect-g12a-odroidc4-odroidg12-v2015.01-20210623-153349 out/u-boot/build/u-boot.bin

# Bananapi M5
collect FIP & build u-boot:

./collect-m5_binaries-git-refboard.sh android-tv-13.0.0_r1 sm1 sm1_bananapim5_v1


# X96 X9 (g12b_w200)
BL2/BL30/BL31/ACS and DDR firmware were recovered from the stock DDR.USB:
`gxlimg -t fip -e` to split the FIP, `gxlimg -t bl2 -u` to unsign BL2
(bl2.bin + acs.bin), bl30.bin/bl301.bin at 0x1000/0xb000 of bl30.enc and
bl31.img at 0x290 of bl31.enc.

./build_x96x9.sh

scripts originally from https://android.googlesource.com/device/amlogic/yukawa/+/refs/heads/master/bootloader/scripts/

# Khadas VIM3 (kvim3, g12b/A311D) and VIM3L (kvim3l, g12a/S905D3)
BL2/BL30/BL31, the DDR firmware and aml_encrypt_g12{a,b} are the blobs
shipped in Khadas' vim3-bootloader tree (bl2/bin, bl30/bin, bl31_1.3/bin,
fip/g12{a,b}). bl301.bin and acs.bin were taken from a `./mk kvim3` /
`./mk kvim3l` build of that tree (fip/_tmp), the same way the other fip
directories freeze the vendor-built pieces. acs.bin is byte-identical to
what ../u-boot builds from board/khadas/kvim3{,l}/firmware/timing.c after
the vendor `parse` step; bl301.bin differs because the vendor scp_task core
is newer.

fip-kvim3l deliberately has no lpddr3_1d.fw: the Khadas g12a bl30 enters
bl301 at 0x1000A000 (40K), and generate-bins-new.sh switches to the 46K
bl30 layout whenever a g12a fip dir contains lpddr3_1d.fw. VIM3L is LPDDR4
only (timing.c), so the firmware is not needed.

./build_kvim3.sh
./build_kvim3l.sh

# Khadas VIM (kvim, gxl/S905X)
BL2/BL30/BL31 and aml_encrypt_gxl are the blobs of Khadas' vim3-bootloader
tree, branch khadas-vims-pie; bl301.bin, bl21.bin and acs.bin come from a
`./mk kvim` build of that tree. gxl needs the ACS (DDR timing) merged into
bl2 by Amlogic's acs_tool.pyc, which is Python 2 bytecode; fip-kvim ships
acs_tool.py, a Python 3 port of it, and generate-bins-new.sh uses that when
present. The gxl branch also packs bl33 lz4 compressed now, as the vendor
fip/gxl/build.sh does (CONFIG_AML_BL33_COMPRESS_ENABLE in arch-gxl/cpu.h).

./build_kvim.sh
