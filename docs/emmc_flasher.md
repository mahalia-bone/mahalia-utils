# How to flash the Mahalia image to the BeagleBone eMMC

Flash the Mahalia image to an SD card in the normal way, but when booting the 
system, press and hold the switch labelled SW2 near the micro SD card.

The four LEDs on the BeagleBone should start to flash slowly. You may now 
release SW2. The flashing process takes around three minutes and once the image 
has completed flashing, the four LEDs should flash much quicker.

You may now power down the BeagleBone safely by pressing the power button and 
waiting for the LEDs to extinguish. After the LEDs have extinguished, please 
wait 30 seconds then remove the power from the BeagleBone.

Success! The micro SD card may now be removed and the next time the system is 
booted it shall boot from the internal eMMC.

If there is a micro SD card plugged in, this will always take priority in the 
boot order.



[     *] A start job is running for dev-mmcblk0p1.device (32s / 1min 30s)


need to modify the /etc/fstab file too
 replace /dev/mmcblk0p1 with /dev/mmcblk1p1
 replace /dev/mmcblk0p2 with /dev/mmcblk1p2

(press space on boot to go to uboot console)

use u-boot-tools to compile the following:

setenv bootargs console=ttyO0,115200n8 noinitrd root=/dev/mmcblk1p2 rootfstype=ext4 rw rootwait
load mmc 1:1 ${loadaddr} zImage
load mmc 1:1 ${fdtaddr} am335x-boneblack-wireless-audio-extension.dtb
bootz ${loadaddr} - ${fdtaddr}


also need to do SSH regen keys