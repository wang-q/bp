#!/bin/bash

# Source common build environment: extract source, setup dirs and functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Extract source code
extract_source

# ./configure --help

# Build mummer with the specified target architecture
if [ "$OS_TYPE" == "windows" ]; then
    CC="gcc"
    CXX="g++"
else
    CC="zig cc -target ${TARGET_ARCH}"
    CXX="zig c++ -target ${TARGET_ARCH}"
fi

CFLAGS="-I${CBP_INCLUDE}" \
CPPFLAGS="-I${CBP_INCLUDE}" \
LDFLAGS="-L${CBP_LIB} -static -largtable2" \
    ./configure \
    --prefix="${TEMP_DIR}/collect" \
    --disable-dependency-tracking \
    || exit 1
make || exit 1
make install || exit 1

# ldd ${TEMP_DIR}/collect/bin/clustalo

# Use build_tar function from common.sh
build_tar
