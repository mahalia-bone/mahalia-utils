apt-get install build-essential git ncurses-dev gcc-arm-linux-gnueabihf bc

git clone git://git.ti.com/ti-linux-kernel/ti-linux-kernel.git

cd ti-linux-kernel

git checkout origin/ti-rt-linux-4.14.y -b ti-rt-linux-4.14.y-cape4all

copy in 0001-cape4all-driver-V2.patch

git apply --reject --whitespace=fix 0001-cape4all-driver-V2.patch

make distclean

./ti_config_fragments/defconfig_builder.sh -t ti_sdk_am3x_rt_release

ARCH=arm make ti_sdk_am3x_rt_release_defconfig

ARCH=arm make menuconfig

Navigate thru menuconfig:

Setup real-time Kernel:
 > General Setup
	> Timers subsystem
		[ ] Old Idle dynticks config

 > Kernel Features
	> Preemption Model
		(X) Fully Preemptible Kernel (RT)

	> Timer frequency
		(X) 250 Hz


 > CPU Power Management
	> CPU Frequency scaling
		[ ] CPU Frequency scaling

	> CPU Idle
		[ ] CPU idle PM support


Compile the driver:
 > Device Drivers
	> Sound card support > Advanced Linux Sound Architecture > ALSA for SoC audio support
		<M>   SoC Audio support for Boneblack Audio Extension

	> File systems > Native language support
		<*> ASCII (United States)


ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make -j6 zImage modules dtbs

rm -rf compiled_modules && mkdir compiled_modules

ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=compiled_modules make modules_install
