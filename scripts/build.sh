#!/usr/bin/env bash

# Example
#
# build.sh /path/to/build_dir 


set -e
set -x

WORK_DIR="${1}"

CGT_VERSION=2.2.1
CGT_INSTALL_DIR="${WORK_DIR}/x-tools"

BUILD_OS=$(uname -s) 
if [[ $BUILD_OS = "Darwin" ]]; then
    # Use GNU tar from Homebrew (brew install gnu-tar)
    TAR=gtar
else
    TAR=tar
fi

echo Building archive...

# Assemble the tarball for the toolchain
# TARGET_TUPLE=ti-cgt-pru_${CGT_VERSION}/
# TAR_PATH="${TARBALL_PATH}"
# TOOLCHAIN_BASE_NAME="$(basename ${TARBALL_PATH%.*.*})/"

mkdir -p $WORK_DIR
cd "$WORK_DIR"

rm -Rf $CGT_INSTALL_DIR
mkdir $CGT_INSTALL_DIR

pwd

# Download PRU CGT from TI's website
wget --continue http://downloads.ti.com/codegen/esd/cgt_public_sw/PRU/${CGT_VERSION}/ti_cgt_pru_${CGT_VERSION}_linux_installer_x86.bin
chmod +x ./ti_cgt_pru_${CGT_VERSION}_linux_installer_x86.bin

# Install CGT
./ti_cgt_pru_${CGT_VERSION}_linux_installer_x86.bin --prefix $CGT_INSTALL_DIR/ --mode unattended

