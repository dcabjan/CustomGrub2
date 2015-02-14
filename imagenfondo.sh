#!/bin/bash

#Imagen de fondo

archivo="/etc/default/grub"
variable="GRUB_BACKGROUND="

#Mostramos la ventana de selección de ficheros
ruta=`zenity --file-selection`

#Si el usuario ha pulsado en "Aceptar"
if [ $? -eq 0 ]
then
	extension=`echo $ruta | tr '/' ' '` #Partimos la ruta en partes

	for ext in $extension
	do
		ext=$ext #En la última vuelta del bucle, nos quedaremos con el nombre del archivo y su extensión
	done

	ext=`echo $ext | cut -d "." -f 2` #Almacenamos la extensión en una variable

	#Comprobamos que la extensión sea válida para GRUB2
	if [ \( $ext = "jpg" \) -o \( $ext = "JPG" \) -o \( $ext = "jpeg" \) -o \( $ext = "JPEG" \) -o \( $ext = "png" \) -o \( $ext = "PNG" \) -o \( $ext = "tga" \) -o \( $ext = "TGA" \) ]
	then
		buscar=`grep $variable $archivo`		
		if  [ "$buscar" != "" ] #Si al realizar el grep, hemos hallado algo, borramos la línea
		then
			sed -i "/$variable/d" $archivo
		fi
			echo "$variable\"$ruta\"" >> $archivo
			zenity --info --text "Cambios realizados correctamente."
	else
		zenity --error --text "Selecciona una imagen válida."
	fi
else
	zenity --error --text "No se guardaron los cambios."
fi

