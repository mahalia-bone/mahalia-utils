```
apt-get install build-essential git gcc-arm-linux-gnueabihf bison flex

git clone git://git.denx.de/u-boot.git mahalia-u-boot
cd mahalia-u-boot
git checkout v2017.09

make am335x_boneblack_defconfig
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make
```
