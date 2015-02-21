##Instalador de archivo y directorios necesarios para la funcionalidad de la herramienta

#Comprobamos si el usuario está identificado como root. De no ser así, se le solicitará la contraseña para poder ejecutar el instalador
if [ "$USER" != "root" ]
then
	echo "No tienes permisos."
else
	#Creacion de directorios que usará la aplicación
	mkdir -p /home/.customgrub2/profiles/.default
	mkdir /home/.customgrub2/logs
	mkdir /bin/.customgrub2
	
	#Copia de los ficheros de GRUB que son objeto de modificación en la aplicación, a modo de "perfil por defecto"
	cp /boot/grub/grub.cfg /etc/default/grub /lib/plymouth/themes/default.grub /home/.customgrub2/profiles/.default

	#Averiguamos la ruta donde está ubicado el instalador
	ruta=`sudo find / -name "install_customgrub2.sh" | tr "/" " "`

	for x in $ruta
	do
		if [ "$x" != "install_customgrub2.sh" ]
		then
			rutaFinal=$rutaFinal"/"$x
		fi		
	done
	
	#Copia los ficheros de aplicación del instalador hasta la carpeta donde operarán
	cp $rutaFinal/files/* /bin/.customgrub2

	#Se busca en el fichero bashrc si hay un alias que pueda interferir con nuestra aplicación. De ser así, se elimina
	sed -i "/customgrub2/d" /etc/bash.bashrc

	#Se asigna el alias "customgrub2" a la aplicación para que, de este modo, el usuario sólo tenga que escribir el nombre y no toda la ruta de la aplicación
	echo "alias customgrub2='/bin/.customgrub2/menu.sh'" >> /etc/bash.bashrc

	#Permisos totales para el usuario y de lectura para el resto
	chmod 744 /bin/.customgrub2/menu.sh
fi
