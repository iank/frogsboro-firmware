# FROGSBORO

This repository is the entry point for the OS image/software for the FROGSBORO board.

* [Blog post describing the board](https://iank.org/posts/frogsboro-embedded-linux-board-sam9x60-sip)
* [Design files repository](https://github.com/iank/frogsboro)

![Assembled board](https://iank.org/static/fd095baec4ae8244d7eccb9bd1d96a66/aaf0c/frogsboro_top_complete.jpg)

# Building FROGSBORO image
```
sudo apt-get install gawk wget git-core git-lfs diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
     pylint3 xterm

git clone git://git.yoctoproject.org/poky -b dunfell                    # 4ddc26f4
git clone git://git.openembedded.org/meta-openembedded -b dunfell       # 7203130e
git clone https://github.com/linux4sam/meta-atmel.git -b dunfell        # 428c0677
git clone https://github.com/iank/meta-frogsboro.git -b dunfell         # 5d843bf8

cd poky
mkdir build-frogsboro
echo 'export TEMPLATECONF=${TEMPLATECONF:-../meta-frogsboro/conf}' > .templateconf

source oe-init-build-env build-frogsboro

MACHINE=sam9x60ek-sd-frogsboro bitbake frogsboro-headless-image

# or

MACHINE=sam9x60ek-sd-frogsboro bitbake frogsboro-catcam-image

```

# Provisioning

After building image as above, or downloading a release image, edit provision.sh and
run it from the build-frogsboro directory. **This script is not safe**. I intend to
clean it up.

# TODO

- wifi:
  - fix rt2800usb problems or change chipsets
  - disable LEDs

- provisioning:
  - clean up script

- yocto BSP:
  - tidy up device tree
  - tidy up u-boot environment
  - rename yocto machine
  - separate non-BSP (linux configuration) recipes into another layer

- application
    - passthrough?
    - signal bot
