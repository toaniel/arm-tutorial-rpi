#!/bin/sh

scriptdir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
base=${scriptdir}/../..

# Get the compiler to use, etc.
. ${base}/shell/common_build.sh
. ${base}/shell/common_functions.sh


# Get the tutorial name from the script directory
tutorial=${scriptdir##*/}

if [ $# -ne 1 ]; then
    echo "usage: build.sh <pi-model>" >&2
    echo "       pi-model options: rpi0, rpi1, rpi1bp, rpi2, rpi3, rpibp" >&2
    exit 1
fi

# The raspberry pi model we're targetting
model="${1}"

disk_name=disk-${model}.img

mkdir -p ${scriptdir}/build && cd ${scriptdir}/build
cmake -G "CodeBlocks - Unix Makefiles" -DBOARD="rpi0" -DTC_PATH="${tcpath}/" -DCMAKE_TOOLCHAIN_FILE=${scriptdir}/toolchain-arm-none-eabi-rpi.cmake ${scriptdir}

if [ $? -ne 0 ]; then
    echo "Failed to configure!" >&2
    exit 1
fi

make VERBOSE=1

if [ $? -ne 0 ]; then
    echo "Failed to build!" >&2
    exit 1
fi

exit 0
