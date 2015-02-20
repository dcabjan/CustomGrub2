#!/bin/bash

#Rootcheck
if [ "$USER" != "root" ]
then
	sudo "$0"
else
	rm -rf /home/.customgrub2
	rm -rf /bin/.customgrub2
	sed -i "/customgrub2/d" /etc/bash.bashrc
fi
