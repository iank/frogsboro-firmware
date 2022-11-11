#!/bin/bash
export FROG_DEVICE=/dev/XXX
export FROG_MNT=/mnt/XXXX
export FROG_SSID="XXXXXXXXX"
export FROG_PSK="XXXXXXXXXX"
export FROG_HOSTNAME="frogsboro"

#echo "Edit before running"; exit 1

test -b ${FROG_DEVICE} || exit 1

sudo dd if=tmp/deploy/images/sam9x60ek-sd-frogsboro/frogsboro-catcam-image-sam9x60ek-sd-frogsboro.wic of=${FROG_DEVICE} bs=4M
sudo mount ${FROG_DEVICE}3 ${FROG_MNT}

# install /data/hostname, ssh key, wpa_supplicant.conf
sudo sh -c "echo ${FROG_HOSTNAME} | tee ${FROG_MNT}/hostname"
sudo install -m 0700 -d ${FROG_MNT}/.ssh
sudo cp ~/.ssh/id_rsa.pub ${FROG_MNT}/.ssh/authorized_keys
sudo chmod 0600 ${FROG_MNT}/.ssh/authorized_keys
sudo sh -c "echo 'ctrl_interface=/var/run/wpa_supplicant\nap_scan=1\n\nnetwork={\n  ssid=\"${FROG_SSID}\"\n  psk=\"${FROG_PSK}\"\n}' | tee ${FROG_MNT}/wpa_supplicant.conf"
sudo chmod 0600 ${FROG_MNT}/wpa_supplicant.conf

sudo umount ${FROG_DEVICE}3

sync

sudo parted ${FROG_DEVICE} resizepart 3 100% -s
sudo e2fsck -f ${FROG_DEVICE}3
sudo resize2fs ${FROG_DEVICE}3
