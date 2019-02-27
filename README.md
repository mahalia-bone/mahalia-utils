# mahalia-utils

This package contains customizations for the _Mahalia_ hearing aid research system, a GNU/Linux distribution for ARM devices based on [Debian](https://www.debian.org/) and [openMHA](https://github.com/HoerTech-gGmbH/openMHA).

Please read our documentation on [how to use the Mahalia system](docs/mahalia-distro.md) and [how to build Mahalia images](docs/mahalia-build.md).

# Building mahalia-utils

```
sudo apt install dh-systemd
./copy-kernel
./build
```

The resulting `deb` package should be in the parent directory.
