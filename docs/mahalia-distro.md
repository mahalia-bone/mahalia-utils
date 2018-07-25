```text
___  ___      _           _ _
|  \/  |     | |         | (_)
| .  . | __ _| |__   __ _| |_  __ _
| |\/| |/ _` | '_ \ / _` | | |/ _` |
| |  | | (_| | | | | (_| | | | (_| |
\_|  |_/\__,_|_| |_|\__,_|_|_|\__,_|
```

# Hearing Aid Research Platform for BeagleBone Black & BeagleBone Black Wireless


contact:  chris <at> 64studio.com



# INTRODUCTION

Mahalia is a pre-configured operating system image for the BeagleBone Black 
(and BeagleBone Black Wireless) to evaluate the performance of the Cape4All 
soundcard with openMHA.

The image is based on Debian Testing and was developed by Christopher Obbard 
at 64 Studio Ltd. for HörTech gGmbH.

The Linux Kernel version 4.14 is used with realtime (RT) patchset. The Cape4All 
driver is included with the Linux Kernel.

The JACK Audio Server is included and starts on boot.

On each reboot of the machine, the default soundcard mixer settings and 
realtime tweaks are applied.

Networking support is provided over the USB host port, a Wi-Fi hotspot and a 
custom Bluetooth Low Energy peripheral.

JACK and openMHA are also started, with port 33337 open for use with the 
openMHA socket interface.

Some basic openMHA configuration files are provided with the image.

An SSH console (with root access) is available on port 22.



# HARDWARE REQUIREMENTS

The image should be written to a Class 10 microSD card of at least 8 GB in 
size. The SanDisk Ultra range is recommended.

A BeagleBone Black or BeagleBone Black Wireless are required. The provided image 
will work with either device without modification. From herein, the device will be 
referred to as "BeagleBone" except for explicitly mentioned.

The Cape4All should be connected to the BeagleBone. Do not connect or 
disconnect the Cape4All while power is applied to the BeagleBone!

A power adapter should be available but not yet connected to the BeagleBone.
Please consult the BeagleBone user manual for a compatible power adapter before 
continuing. The USB Host port may be used as a reliable power connection.

If using the BeagleBone Black (not wireless) an ethernet connection which 
allocates IP addresses using DHCP is recommended, or you may use the USB 
networking.



# INSTALLATION

The following instructions have been written for a unix-like system. The 
commands may differ dependent on the operating system. A microSD card writer is 
required for this step.


Download the image from the 64 Studio Ltd server:

```
$ wget -O mahalia-bone.img http://dl.64studio.net/mahalia/mahalia-bone-v???.img
```

Confirm the checksum of the downloaded image:
```
$ md5sum mahalia-bone.img
```

Find the microSD card writer device name (for example /dev/sdb) and write the image:
```
$ lsblk
$ sudo dd status=progress bs=4M if=mahalia-bone.img of=/dev/sdb conv=fsync
$ sudo sync
```

Insert the SD card into the BeagleBone. If the BeagleBone has an ethernet 
socket, connect it to the network using a patch cable.


Apply power to the 5V socket of the BeagleBone.


The system may take up to 60 seconds to boot, with activity on the 4 "USR" LEDS.
Once JACK and openMHA have started, the USR0 LED shall illuminate solid blue.


# FLASHING MAHALIA TO BEAGLEBONE INTERNAL EMMC
[Please click here](emmc_flasher.md) for more information.



# SERIAL DEBUG CONSOLE

A serial console is available for debugging on the 6-way header. Please consult 
the BeagleBone user manual for more information. The baud-rate is 115200.



# NETWORK INTERFACES

## Wi-Fi Network Interface
If using the BeagleBone Black wireless, a WiFi "hotspot" is created which 
allows your laptop to connect to the device. The SSID is "Mahalia". Once 
connected, the following paragraphs will work as if the device was connected 
using an ethernet lead.

The BeagleBone Black wireless IP address is 10.0.0.1. A DHCP server is setup to 
allow multiple clients.

Please note there are noise issues when using the Wi-Fi hotspot with the Cape4all.

When connected to a console, the Wi-Fi hostspot may be disabled with the following 
command:
```
$ sudo systemctl stop hostapd
```

## Ethernet Network Interface
The BeagleBone Black ethernet IP address will be configured by your router, please 
consult your network administrator.

## USB Network Interface
If using the USB network interface, the static IP address is 192.168.7.2.
[Please click here](usb_networking.md) for more information on the setup of the 
USB network interface.

## BLE Network Interface
The BLE Network Interface is handled by seperate projects called 
`mahalia-ble-peripheral` and `mahalia-ble-server`. Please contact the author for 
more information.


# SSH INTERFACE

An SSH server resides on port 22. On the first-boot of the image, the host keys 
are regenerated for improved security. The following users are available and 
both have SSH access with their relevant password. The MHA user has sudo access.


  u: mha
  p: mahalia

  u: root
  p: toor



# OPENMHA SOCKET INTERFACE

Once connected to the BeagleBone, the openMHA socket interface is available on 
port 33337. On the host laptop, you may connect using netcat:

```
$ nc 10.0.0.1 33337
```

Communication may be tested by pressing the return key, and waiting for the 
response as follows:

```
  (MHA:success)
```

As openMHA has loaded with no configuration file, you must first load a 
configuration file:

netcat command: "?read:/etc/mahalia/mha-test.cfg"


Please note the openMHA configuration is out of the scope of this user manual 
and you should consult the openMHA manual.


After the configuration file has been loaded, you may start processing:

netcat command: "cmd=start"


After the test has finished, you may stop processing:

netcat command: "cmd=stop"


After the stop command has been executed, you may not be able to reload the 
configuration file using the "read" command. 

openMHA and JACKD may be reloaded as follows:

```
$ sudo systemctl restart mahalia
```
  (password mahalia)



# OPENMHA CONFIGURATION FILE

The openMHA configuration file may be modified using the following command:

```
$ nano /etc/mahalia/mha-test.cfg
```
Some openMHA configration files are included with the image, and may be loaded 
using the procedure above:


  /etc/mahalia/mha-test.cfg
    simple test program, routes from MIC1 to HP1.

  /etc/mahalia/mha-matrixmixer.cfg
    from HörTech gGmbH

  /etc/mahalia/mha-dynamiccompressor.cfg
    from HörTech gGmbH



# CAPE4ALL SETTINGS

After starting the system, the soundcard is set to the following default 
settings:

 +0dB gain on microphone sockets
 -6dB gain on headphone sockets


To experiment with different volume settings, connect via SSH and run the 
following command:

```
$ alsamixer
```

The operation of alsamixer is outside the scope of this user manual. Any 
modified settings will return to their defaults noted above.

The default soundcard state may be saved using the following command:

```
$ alsactl store -f /etc/mahalia/cape4all.alsactl.state
```


# JACK LATENCY SETTINGS

The JACK Audio Server settings may be modified by editing the following file: 

```
$ nano /etc/mahalia/config
```

The settings which should be modified (and their defaults) are:
  JACK_SAMPLERATE=24000
  JACK_BUFFER=16
  JACK_FRAMES=2

After modifying, the configuration must be reloaded as follows:

```
$ sudo systemctl restart mahalia
```
  (password mahalia)

This restarts the JACK Audio Server and openMHA processes and may take up to 
a minute to complete.



# SHUTDOWN

After laboratory testing has completed, proper shutdown of the device is 
essential. Improper shutdown may destroy microSD cards and render them useless!

If you are connected via the serial or SSH consoles:

```
$ sudo shutdown now
```

You may press the PWR button to cleanly shut the Mahalia system down. 

All LEDs will extinguish after this system has cleanly shutdown.

If the system becomes unresponsive, pressing the "RESET" switch will restart 
the operating system.

Please wait for one minute after the "PWR" LED extinguishes before removing the 
power adapter or microSD card.



# CAPE4ALL DRIVER JACK MAPPING

This may prove useful when writing openMHA configuration files.

```
system:playback_1     # IC1 Left Playback Data, mapped to LHP_6 (HP1 Left)
system:playback_2     # IC2 Left Playback Data, mapped to LHP_7 (HP2 Left)
system:playback_3     # IC3 Left Playback Data, mapped to LHP_8 (Not committed on PCB)
system:playback_4     # (Not connected)
system:playback_5     # IC1 Right Playback Data, mapped to RHP_6 (HP1 Right)
system:playback_6     # IC2 Right Playback Data, mapped to RHP_7 (HP2 Right)
system:playback_7     # IC3 Right Playback Data, mapped to RHP_8 (Not committed on PCB)
system:playback_8     # (Not connected)

system:capture_1     # IC1 Left Record Data, mapped to LINN6 (MIC1 Left)
system:capture_2     # IC2 Left Record Data, mapped to LINN7 (MIC2 Left)
system:capture_3     # IC3 Left Record Data, mapped to LINN8 (MIC3 Left)
system:capture_4     # (Not connected)
system:capture_5     # IC1 Right Record Data, mapped to RINN6 (MIC1 Right)
system:capture_6     # IC2 Right Record Data, mapped to RINN7 (MIC2 Right)
system:capture_7     # IC3 Right Record Data, mapped to RINN8 (MIC3 Right)
system:capture_8     # (Not connected)
```
