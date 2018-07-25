# Mahalia USB Networking

The Mahalia system has been configured to setup a network interface over the 
USB host port on the BeagleBone Black and BeagleBone Black Wireless. This 
allows both power and data to be communicated to the BeagleBone system as if it 
was connected by Ethernet or Wi-Fi.

First safely power down the Mahalia system and unplug the power lead from the 
DC barrel jack.

Connect the BBB to a USB port on the PC, making sure the USB lead is good 
quality and less than 1m in length. 64 Studio can recommend cables with have 
been marketed as "phone charging" leads.

Note the BBB uses a Mini B USB cable and the BBBW uses a Micro B USB cable.

After connecting the system should boot. After approx 2 minutes, issue the 
following commands on the host system to setup the USB networking.

Please note the device name will differ depending which type of board is 
plugged in and the kernel installed on the host PC.

Find the USB Ethernet interface:
```
$ sudo dmesg --notime
...
usb 5-1.2: New USB device found, idVendor=0525, idProduct=a4a2
usb 5-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1.2: Product: RNDIS/Ethernet Gadget
usb 5-1.2: Manufacturer: Linux 4.14.50-rt30-02012-gaadebddff8a6 with musb-hdrc
cdc_subset: probe of 5-1.2:1.0 failed with error -22
cdc_ether 5-1.2:1.0 usb0: register 'cdc_ether' at usb-0000:03:00.0-1.2, CDC Ethernet Device, fa:28:7d:12:8f:df
cdc_ether 5-1.2:1.0 enp3s0u1u2: renamed from usb0
```


Setup the network interface:
```
$ cat /etc/metwork/interfaces
...
# usb for BBB
auto enp3s0u1u2
iface enp3s0u1u2 inet static
        address 192.168.7.1
        netmask 255.255.255.0
```

Restart the networking service:
```
$ sudo systemctl restart networking
```

Confirm the network is connected:
```
$ ip addr list
...
4: enp3s0u1u2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether fa:28:7d:12:8f:df brd ff:ff:ff:ff:ff:ff
    inet 192.168.7.1/24 brd 192.168.7.255 scope global enp3s0u1u2
       valid_lft forever preferred_lft forever
    inet6 fe80::f828:7dff:fe12:8fdf/64 scope link 
       valid_lft forever preferred_lft forever
```

Connect to the Mahalia system via SSH:
```
$ ssh mha@192.168.7.2
```

Connect to the openMHA socket interface:
```
$ netcat 192.168.7.2 33337
<return key>
(MHA:success)
```

The IP address of the Mahalia system is static and set to 192.168.7.2.

Please refer to the Mahalia user guide for more information on connecting via 
SSH and the openMHA socket interfaces.

If the Mahalia system is rebooted, the host may have to re-issue the commands 
in the "Restart the networking service" section.
