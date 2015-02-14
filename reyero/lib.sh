#!/bin/bash

#Resoluciones de pantalla
function resolucion () {
	#Mostrar la lista de resoluciones disponibles
	resoluciones=`xrandr | sed -n '3,$p'`
	cont=1

	for i in $resoluciones
	do
		result=`echo $resoluciones | cut -d " " -f $cont | tr '' ' \n'`
		aux="$result $aux"	
		let cont=$cont+2
	done

	#Se muestra al usuario una lista con todas las resoluciones disponibles
	opcion=`zenity --list --column "Resoluciones" $aux`

	#Si el usuario ha pulsado en Aceptar, se procede a realizar el cambio
	if [ $? -eq 0 ]
	then
		archivo="/etc/default/grub"
		variable="GRUB_GFXMODE="

		buscar=`grep $variable $archivo | tr -d " " | cut -d "=" -f 2`
		sed -i "s/$buscar/$opcion/g" $archivo

		contador=1
		buscarLinea=`grep $variable $archivo`
		while [ $contador -ne 2 ]
		do
			caracter=`expr substr $buscarLinea $contador 1`
			if [ $caracter = "#" ]
			then
				quitarComentario=`echo $buscarLinea | sed 's/^.//' | tr -d ' '`
				sed -i "s/$buscarLinea/$quitarComentario/g" $archivo	
			fi
		let contador=$contador+1
		done

		zenity --info --text "Cambios realizados correctamente."
	else
		zenity --error --text "No se guardaron los cambios."
	fi
}

#Imagen de fondo
function imgfondo () {
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
}


#Color de fuente del menú

function color () {
	#Mostramos una selección de colores
	color=$(zenity --list --print-column="1" --hide-column="1" --title="Elija un color de resaltado" \
	--column="Valor" --column="Seleccione un color" \
	  "yellow/dark-gray" \ "Amarillo / Gris oscuro" \
		"white/black" \ "Blanco / Negro" \
		"cyan/black" \ "Cian / Negro " \
		"light-green/black" \ "Verde claro / Negro" \
	  "black/red" \ "Negro / Rojo" \
	  "yellow/blue" \ "Amarillo / Azul")

	#Si el usuario ha pulsado en Aceptar, se procede a realizar el cambio
	if [ $? -eq 0 ]
	then
		if [ "$color" = "" ]
		then
			zenity --error --text "Debe seleccionar una opción."
		else
			archivo="/lib/plymouth/themes/default.grub"

			case $1 in
				1)
					echo "Cambiar fuente"
				;;
				2)			
					variable="menu_color_normal="
				;;
				3)
					variable="menu_color_highlight="
				;;
			esac

			buscar=`grep $variable $archivo`
			if  [ "$buscar" != "" ] #Si al realizar el grep, hemos hallado algo, borramos la línea
			then
				sed -i "/$variable/d" $archivo
			fi
			echo "$variable$color" >> $archivo
			zenity --info --text "Cambios realizados correctamente."
		fi
	else
		zenity --error --text "No se guardaron los cambios."
	fi
}
