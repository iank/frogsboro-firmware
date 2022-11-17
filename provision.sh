#!/bin/bash

source $(dirname -- "$0")/config.inc

# Validate parameters
test -b "${FROG_DEVICE}"        || { echo "${FROG_DEVICE} is not a block device" && exit 1; }
test -d "${FROG_MNT}"           || { echo "${FROG_MNT} is not a directory" && exit 1; }
test "x${FROG_SSID}"     != "x" || { echo "FROG_SSID not configured" && exit 1; }
test "x${FROG_PSK}"      != "x" || { echo "FROG_PSK not configured" && exit 1; }
test "x${FROG_HOSTNAME}" != "x" || { echo "FROG_HOSTNAME" not configured && exit 1; }
test -r "${FROG_SSHKEY}"        || { echo "${FROG_SSHKEY} cannot be read" && exit 1; }

IMGTYPE=${1:-headless}
IMGFILE=tmp/deploy/images/sam9x60ek-sd-frogsboro/frogsboro-${IMGTYPE}-image-sam9x60ek-sd-frogsboro.wic

test -r "${IMGFILE}" || { echo "Cannot read $IMGFILE" && exit 1; }

set -x
set -e

# Write and mount image
sudo dd if=${IMGFILE} of=${FROG_DEVICE} bs=4M
sudo mount ${FROG_DEVICE}3 ${FROG_MNT}

# Configure hostname
sudo sh -c "echo ${FROG_HOSTNAME} | tee ${FROG_MNT}/hostname"

# Set up SSH key
sudo install -m 0700 -d ${FROG_MNT}/.ssh
sudo cp ${FROG_SSHKEY} ${FROG_MNT}/.ssh/authorized_keys
sudo chmod 0600 ${FROG_MNT}/.ssh/authorized_keys

# Configure wpa_supplicant
sudo tee "${FROG_MNT}/wpa_supplicant.conf" > /dev/null <<__EOF__
ctrl_interface=/var/run/wpa_supplicant
ap_scan=1

network={
  ssid="${FROG_SSID}"
  psk="${FROG_PSK}"
}
__EOF__

sudo chmod 0600 ${FROG_MNT}/wpa_supplicant.conf

# Copy on_movie_end script if applicable
if [ "x$IMGTYPE" = "xcatcam" ]; then
    sudo cp $(dirname -- "$0")/on_movie_end.sh ${FROG_MNT}/on_movie_end.sh
    sudo chmod 0755 ${FROG_MNT}/on_movie_end.sh
fi

# Unmount
sudo umount ${FROG_DEVICE}3
sync

# Resize data partition to fill SD card
sudo parted ${FROG_DEVICE} resizepart 3 100% -s
sleep 1
sudo e2fsck -f ${FROG_DEVICE}3
sudo resize2fs ${FROG_DEVICE}3

set +x
set +e
