#!/bin/sh
apppath=$(readlink -f $0)
appdir=$(dirname ${apppath})
app=$(basename $apppath)

MOUNT_LOC="/mnt"
SOURCE_LOC="/tmp"
TEST_FILE="random.bin"
TEST_FILE_MD5SUM=""
TEST_FILE_SIZE_MB=100

MD5_FAIL=0
FILE_NOT_FOUND_FAIL=0
PASS=0
DURATION=900

die()
{
       shift
       echo $(hostname): FATAL: "$*" >&2
       exit 1
}
usage()
{
	echo Usage:
	echo "$app [-d|--duration <seconds>] [-s|--size <MB>] <device>"
	echo "    -d Sets the number of seconds to run the test for"
	echo "    -s Sets the size in MB of the random file to use"
	echo "    <device> The device to test, Ex: /dev/sda1"
}

# Note that we use `"$@"' to let each command-line parameter expand to a 
# separate word. The quotes around `$@' are essential!
# We need TEMP as the `eval set --' would nuke the return value of getopt.
TEMP=`getopt -o d:s:h --long duration:,size:,help\
     -n $app -- "$@"`

[ $? != 0 ] && die 2 "Terminating... getopt failed"
eval set -- "$TEMP"
while true ; do
        case "$1" in
        -d|--duration) DURATION="$2"; shift 2;;
        -s|--size) TEST_FILE_SIZE_MB="$2"; shift 2;;
        -h|--help) usage ; exit 0; shift;;
        --) shift ; break ;;
        *) die 2 "Internal error!: $*" ; shift;;
        esac
done

FLASH_DRIVE="$1"

echo "DURATION: ${DURATION} Seconds"
echo "Test File Size: ${TEST_FILE_SIZE_MB} MB"
echo "Drive to test: ${FLASH_DRIVE}"

# Mount the filesystem
if mount | grep -q $FLASH_DRIVE ; then
	echo "`date`- $SECONDS - sb_stress_test - Flash drive mounted"
else
	mount -o sync $FLASH_DRIVE $MOUNT_LOC
	if [ $? -ne 0 ]; then
		echo "`date`- $SECONDS - stress-drive - ERROR - Failed to mount"
		exit 1
	fi

	if mount | grep -q $FLASH_DRIVE ; then
		echo "`date`- $SECONDS - stress-drive - Flash drive mounted"
	fi
fi

# Create the test file
if [ ! -e $SOURCE_LOC/$TEST_FILE ]
then
	echo "`date` - drive_stress_test - Creating test file from /dev/urandom"
	echo
	time dd if=/dev/urandom of=$SOURCE_LOC/$TEST_FILE bs=1M count=$TEST_FILE_SIZE_MB
	if [ $? -ne 0 ]; then
		echo "`date` - drive_stress_test - Generating Test File Failed."
		exit 3
	fi
	sync
	if [ $? -ne 0 ]; then
		echo "`date` - drive_stress_test - sync Test File Failed."
		exit 3
	fi
else
	echo "`date` - drive_stress_test - Using existing test file"
fi
echo

# Get the MD5SUM of the test file
echo "`date` - drive_stress_test - Calculating MD5SUM of test file"
TEST_FILE_MD5SUM=`md5sum $SOURCE_LOC/$TEST_FILE | cut -f1 -d' '`

echo "`date` - drive_stress_test - Copying test file to drive"
cp $SOURCE_LOC/$TEST_FILE $MOUNT_LOC

# Set end time, default 15 minutes 
end=$((SECONDS+DURATION)) 

while [ $SECONDS -lt $end ]; do 
	# Make sure file exists
	if [ -f $MOUNT_LOC/$TEST_FILE ]; then 
		# Get MD5 of file on drive storage
		echo "`date`- $SECONDS - stress-drive - Calculating MD5SUM"
		MD5SUM=`md5sum $MOUNT_LOC/$TEST_FILE | cut -f1 -d' '`
		# Verify MD5
		if [ "$MD5SUM" != "$TEST_FILE_MD5SUM" ]; then
			echo "`date` - $SECONDS - stress-drive - ERROR - MD5SUM not equal"
			MD5_FAIL=$((MD5_FAIL+1))
		else
			echo "`date` - $SECONDS - stress-drive - MD5SUM passed"
			PASS=$((PASS+1))
		fi
	else
		echo "`date` - $SECONDS - stress-drive - ERROR - Can't find test file. Make sure the random.bin is on the drive"
		FILE_NOT_FOUND_FAIL=$((MD5_FAIL+1))
		exit 3
	fi
	# Clear read cache
	echo 3 > /proc/sys/vm/drop_caches
done	

echo "`date`- $SECONDS - stress-drive - MD5 failures $MD5_FAIL"
echo "`date`- $SECONDS - stress-drive - File not found failures $FILE_NOT_FOUND_FAIL"
echo "`date`- $SECONDS - stress-drive - Passes $PASS"

umount /mnt
