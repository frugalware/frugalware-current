#!/bin/sh

[ -f "/etc/sysconfig/eeepc" ] && source "/etc/sysconfig/eeepc"

case $3 in
	#Fn+F1
	00000080)
		#echo "a" >> /var/log/messages 
		;;
	# Toggle Wireless
	00000010)
		echo "1" > /sys/devices/platform/eeepc/wlan
		;;
	00000011)
		echo "0" > "/sys/devices/platform/eeepc/wlan"
		;;
	#Fn+F3
	00000030)
		#echo "d" >> /var/log/messages
		;;
	00000031)
		#echo "e" >> /var/log/messages
		;;
	00000032)
		#echo "f" >> /var/log/messages
		;;
	#Fn+F6
	00000012)
		#${TASK_MANAGER}
		;;
	# Toggle Mute
	00000013)
		amixer -q set "${VOLUME_NAME}" toggle
		;;
	# Lower Volume
	00000014)
		amixer -q set "${VOLUME_NAME}" "${VOLUME_INCREMENT}%-"
		;;
	# Raise Volume
	00000015)
		amixer -q set "${VOLUME_NAME}" "${VOLUME_INCREMENT}%+"
		;;
	# Turn off backlight
	00000016)
		${SCREEN_OFF}
		;;
	#Fn+F3
	0000002x)
		#echo "k" >> /var/log/messages
		;;
	#Fn+F4
	0000002x)
		#echo "k" >> /var/log/messages
		;;
esac

#echo $3 >> /var/log/messages