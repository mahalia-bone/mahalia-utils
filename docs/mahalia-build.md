[PDK](https://github.com/64studio/pdk) is the Platform Development Kit that we use for creating the [Mahalia](https://github.com/mahalia-bone/) distro images, based on Debian GNU/Linux.

Most Mahalia users will not need to create their own distro images. To download and flash ready-made Mahalia images, please follow the instructions in the [mahalia-distro](https://github.com/mahalia-bone/mahalia-utils/blob/master/docs/mahalia-distro.md) documentation.

If you would like to create a new Mahalia image with your own modifications, read on! The following instructions are based on using a Debian GNU/Linux 9 'stretch' build server.

## Install PDK

```bash
sudo apt install apt-transport-https
echo "deb https://apt.64studio.net stretch main" | sudo tee /etc/apt/sources.list.d/64studio.list
wget -qO - https://apt.64studio.net/archive-keyring.asc | sudo apt-key add -
sudo apt update
sudo apt install pdk pdk-mediagen rng-tools
```
- Ignore the `rng-tools` service failing to start with "Cannot find a hardware RNG device to use." You won't need this to run as a service for now

## APT Repository key

- When using gpg to generate an APT repository key, make the email address apt@your-domain where _your-domain_ is the domain name used by your project. This will not necessarily be the existing project domain name if you are serving packages and images from somewhere else.
- You will be prompted to create a signing password, twice. To enable automated builds later, you can automate signing with [gpg-preset-passphrase](https://www.gnupg.org/documentation/manuals/gnupg/gpg_002dpreset_002dpassphrase.html) running on each boot.

```bash
sudo rngd -r /dev/urandom
gpg --gen-key
```

## Download PDK project 'Mahalia'

- Download the archive containing the PDK project to your build server. We'll assume this file is called mahalia-distro_master.tar.gz and it will be downloaded into the home directory of the 'apt' user that we'll create to serve packages and images.

```bash
sudo adduser apt
sudo su apt
cd ~
wget http://your-domain/mahalia-distro_master.tar.gz
mkdir -p ~/pdk/projects
tar zxvf ~/mahalia-distro_master.tar.gz -C ~/pdk/projects
```

## Initialise project

```bash
cd ~/pdk/projects/mahalia-distro
git init
```

## Modify project for your needs

- You will need to change the \<mediagen.root-password\> for the generated image, the \<apt-deb.key\> to the email address apt@your-domain that you created earlier
- Set the MEDIAGEN_PATH to the location of PDK's mediagen script on your system. If you have installed pdk-mediagen from the 64 Studio apt repository mentioned above, this path will be /usr/share/pdk-mediagen/mediagen

```bash
nano Makefile
make
```
Running _make_ will run a PDK channel update, resolve dependencies for the local packages which are custom for Mahalia, and write out the mahalia.xml project file.


## Build image

```bash
make image
```
- This step uses `sudo`, so you may be prompted for the 'apt' user's password as well as your GnuPG passphrase.

- All the standard Debian packages required will be downloaded, and the distro image created. This can take ten minutes to half an hour, depending on the speed of the build server's CPU. 

- After this, you should find the _out.img_ file and a compressed version out.img.gz in your PDK workspace.

- PDK will create a checksum file _out.img.md5sum_ for users to compare against when the image is downloaded. 

- You may find it useful to rename this image to give it a distinct version number. In this case you might prefer to recreate the checksum file and compressed image to reflect the new filename.


## Flash image

- Please refer to the [Mahalia flashing instructions](https://github.com/mahalia-bone/mahalia-utils/blob/master/docs/mahalia-distro.md) to get the image onto the BeagleBone.

- See the [PDK project on GitHub](https://github.com/64studio/pdk) for more details of how to use PDK.
