# Building FROGSBORO image
```
sudo apt-get install gawk wget git-core git-lfs diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
     pylint3 xterm

git clone git://git.yoctoproject.org/poky -b dunfell                    # 4ddc26f4
git clone git://git.openembedded.org/meta-openembedded -b dunfell       # 7203130e
git clone https://github.com/linux4sam/meta-atmel.git -b dunfell        # 428c0677
git clone https://github.com/iank/meta-frogsboro.git -b dunfell         # ac18e0a3

cd poky
mkdir build-frogsboro
echo 'export TEMPLATECONF=${TEMPLATECONF:-../meta-frogsboro/conf}' > .templateconf

source oe-init-build-env build-frogsboro

MACHINE=sam9x60ek-sd-frogsboro bitbake microchip-headless-image
```
# TODO

- provisioning:
    - wifi
    - ssh key
    - hostname
- read-only rootfs
- tidy up device tree
- tidy up u-boot environment
- rename machine config