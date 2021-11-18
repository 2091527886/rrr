#!/bin/bash

if [ $VARIANT  == "debug" ]; then
   DIST="qti-distro-base-debug"
   KERNEL_VARIANT="debug_defconfig"
   BUILDDIR="build-qti-distro-base-debug"
else
   DIST="qti-distro-base-user"
   KERNEL_VARIANT="defconfig"
   BUILDDIR="build-qti-distro-base-user"
fi

#set env
export MACHINE=genericarmv8
export DISTRO=$DIST
source poky/qti-conf/set_bb_env.sh $BUILDDIR

if [ "${RECOMPILE_KERNEL}" == "1" ]; then
    echo "rebuilding kernel"
    cd ../src/kernel-5.10/kernel_platform
    BUILD_CONFIG=common/build.config.msm.*.tuivm EXTRA_CONFIGS=./prebuilts/qcom_boot_artifacts/build.config.qc.standalone VARIANT=$KERNEL_VARIANT ./build/build.sh
    if [ ! -f out/msm-*-*_tuivm-$KERNEL_VARIANT/dist/Image ]; then
        echo "Kernel compilation failed !!"
        exit 1
    fi
    rm -rf ../out/
    cp -rp ./out ../
    cd ../../../
    bitbake -c cleanall linux-platform && bitbake -c cleanall linux-dummy && bitbake -c cleanall qti-vm-image
fi

bitbake qti-vm-image
