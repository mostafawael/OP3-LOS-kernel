#!/bin/bash

#
#  Build Script for Render Kernel for OnePlus 3!
#  Based off AK'sbuild script - Thanks!
#

# Bash Color
rm .version
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
KERNEL="Image.gz-dtb"
DEFCONFIG="lineageos_oneplus3_defconfig"

# Kernel Details
VER=v001
VARIANT="HelixKernel-OP3"

# Vars
export LOCALVERSION=~`echo $VER`
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=MostafaWael
export KBUILD_BUILD_HOST=TeamHelix
export CCACHE=ccache
export TOOLCHAIN=${HOME}/Documents/toolchains/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-

# Paths
KERNEL_DIR=`pwd`
REPACK_DIR="${HOME}/Documents/anykernel2"
PATCH_DIR="${HOME}/Documents/anykernel2/patch"
MODULES_DIR="${HOME}/Documents/anykernel2/modules"
ZIP_MOVE="${HOME}/Documents/kernel-builds"
ZIMAGE_DIR="${HOME}/Documents/OP3-LOS-kernel/arch/arm64/boot"

# Functions
function clean_all {
		cd $REPACK_DIR
		rm -rf $MODULES_DIR/*
		rm -rf $KERNEL
		rm -rf $DTBIMAGE
		rm -rf zImage
		cd $KERNEL_DIR
		echo
		make clean && make mrproper
}

function make_kernel {
		echo
		make ARCH=arm64 CROSS_COMPILE=$TOOLCHAIN $DEFCONFIG
		make ARCH=arm64 CROSS_COMPILE=$TOOLCHAIN $THREAD
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/zImage
}

function make_modules {
		rm `echo $MODULES_DIR"/*"`
		find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
}

function make_zip {
		cd $REPACK_DIR
		zip -r9 "$VARIANT"-"$VER".zip *
		mv "$VARIANT"-"$VER".zip $ZIP_MOVE
		cd $KERNEL_DIR
}


DATE_START=$(date +"%s")

echo -e "${green}"
echo "Helix Kernel Creation Script:"
echo -e "${restore}"

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build kernel (y/n)? " dchoice
do
case "$dchoice" in
	y|Y)
		make_kernel
		make_modules
		make_zip
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
