# How to flash the Mahalia image to the BeagleBone eMMC

Flash the Mahalia image to an SD card in the normal way, but when booting the 
system, press and hold the switch labelled SW2 near the micro SD card.

The USR3 LED on the BeagleBone should start to flash slowly. You may now 
release SW2. The flashing process takes around three minutes and once the image 
has completed flashing, the USR3 LED should flash much quicker.

You may now power down the BeagleBone safely by pressing the power button and 
waiting for the LED to extinguish. After the LEDs have extinguished, please 
wait 30 seconds then remove the power from the BeagleBone.

Success! The micro SD card may now be removed and the next time the system is 
booted it shall boot from the internal eMMC.

If there is a micro SD card plugged in, this will always take priority in the 
boot order.
