# Check for LD_LIBRARY_PATH being set, which can break SDK and generally is a bad practice
# http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html#AEN80
# http://xahlee.info/UnixResource_dir/_/ldpath.html
# Only disable this check if you are absolutely know what you are doing!
if [ ! -z "$LD_LIBRARY_PATH" ]; then
    echo "Your environment is misconfigured, you probably need to 'unset LD_LIBRARY_PATH'"
    echo "but please check why this was set in the first place and that it's safe to unset."
    echo "The SDK will not operate correctly in most cases when LD_LIBRARY_PATH is set."
    echo "For more references see:"
    echo "  http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html#AEN80"
    echo "  http://xahlee.info/UnixResource_dir/_/ldpath.html"
    return 1
fi
while ! which arm-none-eabi-gcc > /dev/null
do
	read -ep "Enter path to gcc toolchain supplying arm-none-eabi-gcc [i.e. /opt/gcc-arm-none-eabi-10-2020-q4-major] " path
	if [ -x $path/bin/arm-none-eabi-gcc ]
	then
		export PATH="${path}/bin:$PATH"
		export SDKTARGETSYSROOT="$path"
		break;
	else "echo $path is not a valid toolchain directory"
	fi
done

if [ "x" == "x$SOCEDS_DEST_ROOT" ]
then
	read -ep "Enter path to SOCEDS root (SOCEDS_DEST_ROOT variable)" soc
	export SOCEDS_DEST_ROOT=$soc
fi
export CC="arm-none-eabi-gcc  -march=armv7-a -mfpu=neon -mfloat-abi=softfp -mcpu=cortex-a9 --sysroot=$SDKTARGETSYSROOT"
export CXX="arm-none-eabi-g++  -march=armv7-a -mfpu=neon -mfloat-abi=softfp -mcpu=cortex-a9 --sysroot=$SDKTARGETSYSROOT"
export CPP="arm-none-eabi-gcc -E  -march=armv7-a -mfpu=neon -mfloat-abi=softfp -mcpu=cortex-a9 --sysroot=$SDKTARGETSYSROOT"
export AS="arm-none-eabi-as "
export LD="arm-none-eabi-ld  --sysroot=$SDKTARGETSYSROOT"
export GDB=arm-none-eabi-gdb
export STRIP=arm-none-eabi-strip
export RANLIB=arm-none-eabi-ranlib
export OBJCOPY=arm-none-eabi-objcopy
export OBJDUMP=arm-none-eabi-objdump
export AR=arm-none-eabi-ar
export NM=arm-none-eabi-nm
export M4=m4
export TARGET_PREFIX=arm-none-eabi-
export CFLAGS=" -O2 -pipe -g -feliminate-unused-debug-types "
export CXXFLAGS=" -O2 -pipe -g -feliminate-unused-debug-types "
export LDFLAGS="-Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed"
export CPPFLAGS=""
export KCFLAGS="--sysroot=$SDKTARGETSYSROOT"
export ARCH=arm
export CROSS_COMPILE=arm-none-eabi-

echo Environment set up for cross compiling for arm-none-eabi- with Intel SOCEDS from $SOCEDS_DEST_ROOT
echo
