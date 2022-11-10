# Building FROGSBORO image
```
sudo apt-get install gawk wget git-core git-lfs diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
     pylint3 xterm

git clone git://git.yoctoproject.org/poky -b dunfell                    # 4ddc26f4
git clone git://git.openembedded.org/meta-openembedded -b dunfell       # 7203130e
git clone https://github.com/linux4sam/meta-atmel.git -b dunfell        # 428c0677

cd poky
mkdir build-microchip

# Edit .templateconf
# export TEMPLATECONF=${TEMPLATECONF:-../meta-atmel/conf}

source oe-init-build-env build-microchip

MACHINE=sam9x60ek-sd bitbake microchip-headless-image
```
# TODO

- frogsboro BSP layer
- g_serial gadget
- rt2870 firmware
- wifi provisioning
- read-only rootfs
- tidy up device tree
