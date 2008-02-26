install fuse /sbin/modprobe --ignore-install fuse && \
	{ if grep -q fusectl /proc/filesystems; then /bin/mount -t fusectl fusectl /sys/fs/fuse/connections; fi ; : ; }
remove fuse { if grep -q " /sys/fs/fuse/connections " /proc/mounts; then /bin/umount /sys/fs/fuse/connections; fi } && \
	/sbin/modprobe -r --ignore-remove fuse
