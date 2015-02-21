#!/bin/bash

#Comprobamos que el usuario sea root. De no ser así, se le solicitará la contraseña
if [ "$USER" != "root" ]
then
	echo "No tienes permisos."
else
	#Borramos el directorio donde se concentran los perfiles y los ficheros log
	rm -rf /home/.customgrub2

	#Borramos el directorio donde se concentran los ficheros de aplicación
	rm -rf /bin/.customgrub2

	#Eliminamos el alias que tenía asignado la aplicación
	sed -i "/customgrub2/d" /etc/bash.bashrc
fi
