DESCRIPTION = "CMR Image"

include recipes/images/mitysom-image-base.bb

IMAGE_FEATURES += " \
	x11-sato \
	"

IMAGE_INSTALL += " \
	test-scripts \
	iperf3 \
	e2fsprogs \
	strace \
	gdb \
	memtester \
	"
