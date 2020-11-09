#!/bin/bash 
apppath=$(readlink -f $0)
appdir=$(dirname ${apppath})
app=$(basename $apppath)

#
# function die
# print an error message and exit with status
# args 1- are the message to print
die()
{
       shift
       echo $(hostname): FATAL: "$*" >&2
       exit 1
}
usage()
{
	echo Usage:
	echo "$app [-s|--size <size>] [-o|--outfile <outfile>] [-p|--preloader <preloader bin>]" 
	echo "     [-e|--environment <env binary>] [-u|--uboot <u-Boot bin>] [-a|--sparse]"
	echo "     [-f|--fatfile <file>] [-r|--rfsoverlay <dir>] [-t|--fatoverlay <dir>]"
	echo "     [-v] [-g] [-d|--device <CycloneV|Arria10>] [-F|--fatsize <size>] [<root.tar.gz>]"
	echo "    -d device type [CycloneV Arria10]"
	echo "    -s size of image [default $SD_CARD_SIZE_MB MB]"
	echo "    -o name of the output file [default is $IMAGE_FILE]"
	echo "    -p preloader to be used, only Cyclone V"
	echo "    -e u-Boot environment to be used"
	echo "    -u u-Boot image to be used"	
	echo "    -a create sparse image file (for bmaptool writing)"
	echo "    -f Files to add to the FAT partition (rbf images)"
	echo "    -r File structure overlay to be put on top of root fs"
	echo "    -t FAT structure overlay to be put on top of FAT partition"
	echo "    -v sets verbose flag in shell"
	echo "    -g will result in the output file being compressed with gzip"
	echo "    -F size of the FAT partition in MB"
	echo "    <root.tar.gz> is the yocto filesystem tarball to use"
}

DEV_TYPE=CycloneV
IMAGE_FILE=sd_card.img
UBOOT_IMG=u-boot.img
PRELOADER=preloader-mkpimage.bin
UBOOTENV=ubootenv.bin
SD_CARD_SIZE_MB=1024
FAT_SIZE_MB=256
A2_SIZE_MB=1
GZIP=N
FAT_FILES=""
BOOT_FILES=""
ROOT_FS_OVERLAY=""
FAT_OVERLAY=""
USE_SPARSE="no"
ROOT_BALL=""

guestfish=$(which guestfish)
[ -n "$guestfish" ] || die guestfish missing.. run sudo apt-get install libguestfs-tools

# Note that we use `"$@"' to let each command-line parameter expand to a 
# separate word. The quotes around `$@' are essential!
# We need TEMP as the `eval set --' would nuke the return value of getopt.
TEMP=`getopt -o o:s:p:e:u:d:f:b:r:t:F:ghva --long outfile:,size:,preloader:,environment:,uboot:,device:,fatfile:,bootfile:,rfsoverlay:,fatoverlay:,fatsize:,gzip,help,verbose,sparse\
     -n $app -- "$@"`

[ $? != 0 ] && die 2 "Terminating... getopt failed"
eval set -- "$TEMP"
while true ; do
        case "$1" in
	-a|--sparse) USE_SPARSE="yes"; shift ;;
        -o|--outfile) IMAGE_FILE="$2"; shift 2;;
        -s|--size) SD_CARD_SIZE_MB="$2"; shift 2;;
        -g|--gzip) GZIP=Y; shift ;;
        -k|--keep) keepfiles=Y; shift ;;
        -v|--verbose) set -v; shift ;;
        -h|--help) usage ; exit 0; shift;;
	-p|--preloader) PRELOADER="$2"; shift 2;;
	-e|--environment) UBOOTENV="$2"; shift 2;;
	-u|--uboot) UBOOT_IMG="$2"; shift 2;;
	-d|--device) DEV_TYPE="$2"; shift 2;;
	-f|--fatfile) FAT_FILES="${FAT_FILES} $2"; shift 2;;
	-b|--bootfile) BOOT_FILES="${BOOT_FILES} $2"; shift 2;;
	-r|--rfsoverlay) ROOT_FS_OVERLAY="$2"; shift 2;;
	-t|--fatoverlay) FAT_OVERLAY="$2"; shift 2;;
	-F|--fatsize) FAT_SIZE_MB="$2"; shift 2;;
        --) shift ; break ;;
        *) die 2 "Internal error!: $*" ; shift;;
        esac
done


if [ "$#" -eq 1 ] ; then
	ROOT_BALL=$(readlink -f $1)
fi

[ -f $UBOOT_IMG ] || die u-Boot image \"$UBOOT_IMG\" does not exist
[ -f $UBOOTENV ] || die u-Boot env image \"$UBOOTENV\" does not exist
if [ $DEV_TYPE == "CycloneV" ] 
then
	[ -f $PRELOADER ] || die Preloader image \"$PRELOADER\" does not exist
fi

rm -rf $IMAGE_FILE
if [ $USE_SPARSE == "yes" ]
then
	# generate image file using a sparse file
	truncate -s${SD_CARD_SIZE_MB}M $IMAGE_FILE || die unable to create SD image file
else
	# Create a blank image 
	dd if=/dev/zero of=$IMAGE_FILE bs=1M count=$SD_CARD_SIZE_MB || die unable to create SD image file
fi

#######################################
###           PARTITIONING          ###
#######################################
fat_start=8192
fat_sectors=$(($FAT_SIZE_MB * 2 * 1024))
fat_end=$(($fat_start + $fat_sectors))
a2_start=$(($fat_end + 1))
a2_sectors=$(($A2_SIZE_MB * 2 * 1024))
a2_end=$(($a2_start + $a2_sectors))
root_start=$(($a2_end + 1))
root_end=$((($SD_CARD_SIZE_MB-1) * 2 * 1024))

echo "Creating partitions"
# Create partitions
# /dev/sda1 fat for fpga images
# /dev/sda2 0xA2 for boot loader
# /dev/sda3 ext3 for root fs
guestfish --rw --format=raw -a ${IMAGE_FILE} << EOF
	run
	part-init /dev/sda mbr 
	part-add /dev/sda p ${fat_start} ${fat_end}
	part-set-mbr-id /dev/sda 1 0xb
	mkfs vfat /dev/sda1 
	part-add /dev/sda p ${a2_start} ${a2_end}
	part-set-mbr-id /dev/sda 2 0xa2
	part-add /dev/sda p ${root_start} ${root_end}
	part-set-mbr-id /dev/sda 3 0x83
	mke2fs /dev/sda3 fstype:ext3
EOF

#############################################
###        COPYING ROOTFS TARBALL         ###
#############################################
if [ "${ROOT_BALL}" != "" ]
then
echo "Copying in rootfs"
# Copy in rootfs tarball to /dev/sda3
guestfish -a ${IMAGE_FILE} << EOF
	run
	mount /dev/sda3 /
	tar-in  ${ROOT_BALL} / compress:gzip
	chown 0 0 /
	umount /
	sync
EOF
fi

#############################################
###           COPYING PRELOADER           ###
#############################################
echo "Copying in bootloader"
if [ "${DEV_TYPE}" == "Arria10" ]
then
# No preloader, so it must be a A10
# write u-boot to /dev/sda2
uboot_img=$(basename ${UBOOT_IMG})
ubootenv=$(basename ${UBOOTENV})
guestfish -a ${IMAGE_FILE} << EOF
	run
	mount /dev/sda3 /
	mkdir /GUESTFISH_TEMP
	upload ${UBOOT_IMG} /GUESTFISH_TEMP/${uboot_img}
	upload ${UBOOTENV} /GUESTFISH_TEMP/${ubootenv}
	copy-file-to-device /GUESTFISH_TEMP/${uboot_img} /dev/sda2 
	copy-file-to-device /GUESTFISH_TEMP/${ubootenv} /dev/sda destoffset:512
	rm-rf /GUESTFISH_TEMP
	chown 0 0 /
	umount /
	sync
EOF
else
# Has preloader, so it must be a Cyclone V
# write preloader and u-boot to /dev/sda2
uboot_img=$(basename ${UBOOT_IMG})
preloader=$(basename ${PRELOADER})
ubootenv=$(basename ${UBOOTENV})
guestfish -a ${IMAGE_FILE} << EOF
	run
	mount /dev/sda3 /
	mkdir /GUESTFISH_TEMP
	upload ${UBOOT_IMG} /GUESTFISH_TEMP/${uboot_img}
	upload ${PRELOADER} /GUESTFISH_TEMP/${preloader}
	upload ${UBOOTENV}  /GUESTFISH_TEMP/${ubootenv}
	copy-file-to-device /GUESTFISH_TEMP/${preloader} /dev/sda2
	copy-file-to-device /GUESTFISH_TEMP/${uboot_img} /dev/sda2 destoffset:256k
	copy-file-to-device /GUESTFISH_TEMP/${ubootenv}  /dev/sda destoffset:512
	rm-rf /GUESTFISH_TEMP
	chown 0 0 /
	umount /
	sync
EOF
fi

#############################################
###           COPYING FAT FILES           ###
#############################################
if [ "${FAT_FILES}" != "" ]
then
echo "Copying in FAT files"
guestfish -a ${IMAGE_FILE} << EOF
	run
	mount /dev/sda1 /
	copy-in ${FAT_FILES} /
	umount /
	sync
EOF
fi

#############################################
###           COPYING BOOT FILES          ###
#############################################
if [ "${BOOT_FILES}" != "" ]
then
echo "Copying in boot files"
guestfish -a ${IMAGE_FILE} << EOF
	run
	mount /dev/sda3 /
	copy-in ${BOOT_FILES} /boot
	umount /
	sync
EOF
fi

#############################################
###           COPYING ROOT FS Overlay     ###
#############################################
if [ ! -z "$ROOT_FS_OVERLAY" ] 
then
echo "Copying in root fs overlay"
tar -czf root_fs_overlay.tar.gz -C ${ROOT_FS_OVERLAY} .
guestfish -a ${IMAGE_FILE} << EOF
	run
	mount /dev/sda3 /
	tar-in root_fs_overlay.tar.gz / compress:gzip
	chown 0 0 /
	umount /
	sync
EOF
rm root_fs_overlay.tar.gz
fi

#############################################
###           COPYING FAT Overlay         ###
#############################################
if [ ! -z "$FAT_OVERLAY" ] 
then
echo "Copying in fat overlay"
tar -czf fat_overlay.tar.gz -C ${FAT_OVERLAY} .
guestfish -a ${IMAGE_FILE} << EOF
	run
	mount /dev/sda1 /
	tar-in fat_overlay.tar.gz / compress:gzip
	chown 0 0 /
	umount /
	sync
EOF
rm fat_overlay.tar.gz
fi


#############################################
###           COMPRESSING IMAGE           ###
#############################################
if [ "Y" == "$GZIP" ] ; then
	echo compressing ${IMAGE_FILE}
	gzip -f ${IMAGE_FILE}
fi

exit 0
