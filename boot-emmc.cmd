# boot from eMMC

# command line
setenv bootargs console=ttyO0,115200n8 noinitrd root=/dev/mmcblk1p2 rootfstype=ext4 rw rootwait

# fallback devicetree blob
setenv dtb_file am335x-boneblack-audio-extension.dtb

# check if running boneblack wireless
if test $board_name = BBBW; then
	setenv dtb_file am335x-boneblack-wireless-audio-extension.dtb
fi

# load kernel & devicetree to memory
load mmc 1:1 ${loadaddr} zImage
load mmc 1:1 ${fdtaddr} ${dtb_file}

# boot!
bootz ${loadaddr} - ${fdtaddr}
