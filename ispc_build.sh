#!/usr/bin/env bash
set -eu

OPEN3D_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
OPEN3D_BUILD="${OPEN3D_ROOT}/build"

clean_up() {
    pushd ${OPEN3D_ROOT}
    rm -rf ${OPEN3D_BUILD} || true
    mkdir ${OPEN3D_BUILD} || true
    rm -f build_release.log
    rm -f build_debug.log
    popd
}

# Source ISPC
source /opt/intel/oneapi/compiler/latest/env/vars.sh

# Release build
clean_up
pushd ${OPEN3D_BUILD}
cmake \
    -DBUILD_CUDA_MODULE=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_JUPYTER_EXTENSION=OFF \
    -DGLIBCXX_USE_CXX11_ABI=OFF \
    -DBUILD_COMMON_CUDA_ARCHS=OFF \
    -DCMAKE_C_COMPILER=icx \
    -DCMAKE_CXX_COMPILER=icpx \
    -DUSE_BLAS=OFF \
    -DBUILD_FILAMENT_FROM_SOURCE=OFF \
    -DBUILD_LIBREALSENSE=OFF \
    -DBUILD_RPC_INTERFACE=OFF \
    -DBUILD_BENCHMARKS=ON \
    -DBUILD_GUI=ON \
    -DBUILD_TENSORFLOW_OPS=OFF \
    -DBUILD_PYTORCH_OPS=OFF \
    -DBUILD_UNIT_TESTS=ON \
    -DCMAKE_INSTALL_PREFIX=~/open3d_install .. \
    &> >(tee -a "../build_release.log")
make VERBOSE=1 Open3D -j$(nproc) &> >(tee -a "../build_release.log")
popd

# Clean up
clean_up

# Debug build
clean_up
pushd ${OPEN3D_BUILD}
cmake \
    -DBUILD_CUDA_MODULE=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DBUILD_JUPYTER_EXTENSION=OFF \
    -DGLIBCXX_USE_CXX11_ABI=OFF \
    -DBUILD_COMMON_CUDA_ARCHS=OFF \
    -DCMAKE_C_COMPILER=icx \
    -DCMAKE_CXX_COMPILER=icpx \
    -DUSE_BLAS=OFF \
    -DBUILD_FILAMENT_FROM_SOURCE=OFF \
    -DBUILD_LIBREALSENSE=OFF \
    -DBUILD_RPC_INTERFACE=OFF \
    -DBUILD_BENCHMARKS=ON \
    -DBUILD_GUI=ON \
    -DBUILD_TENSORFLOW_OPS=OFF \
    -DBUILD_PYTORCH_OPS=OFF \
    -DBUILD_UNIT_TESTS=ON \
    -DCMAKE_INSTALL_PREFIX=~/open3d_install .. \
    &> >(tee -a "../build_debug.log")
make VERBOSE=1 Open3D -j$(nproc) &> >(tee -a "../build_debug.log")
popd


