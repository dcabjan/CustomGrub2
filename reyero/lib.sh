#!/bin/bash

#Montamos la lista de las resoluciones disponibles
function listaResoluciones() {
	resoluciones=`xrandr | sed -n '3,$p'`
	cont=1

	for i in $resoluciones
	do
		result=`echo $resoluciones | cut -d " " -f $cont | tr '' ' \n'`
		aux="$result $aux"	
		let cont=$cont+2
	done
	
	echo "$aux"
}

#Resoluciones de pantalla
function resolucion () {
	#Si el usuario ha pulsado en Aceptar, se procede a realizar el cambio
	if [ $? -eq 0 ]
	then
		if [ "$opcion" = "" ]
		then
			codigoError=3
			return $codigoError
		else
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

			codigoError=0
			return $codigoError
		fi
	else
		codigoError=1
		return $codigoError
	fi
}

#Imagen de fondo
function imgfondo () {
	archivo="/etc/default/grub"
	variable="GRUB_BACKGROUND="

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
		if [ "$ext" != "" ]
		then
			if [ \( $ext = "jpg" \) -o \( $ext = "JPG" \) -o \( $ext = "jpeg" \) -o \( $ext = "JPEG" \) -o \( $ext = "png" \) -o \( $ext = "PNG" \) -o \( $ext = "tga" \) -o \( $ext = "TGA" \) ]
			then
				buscar=`grep $variable $archivo`		
				if  [ "$buscar" != "" ] #Si al realizar el grep, hemos hallado algo, borramos la línea
				then
					sed -i "/$variable/d" $archivo
				fi

				echo "$variable\"$ruta\"" >> $archivo
				codigoError=0
				return $codigoError
			else
				codigoError=2
				return $codigoError
			fi
		else
			codigoError=1
			return $codigoError
		fi
	else
		codigoError=1
		return $codigoError
	fi
}


#Color de fuente del menú

function color () {
	#Si el usuario ha pulsado en Aceptar, se procede a realizar el cambio
	if [ $? -eq 0 ]
	then
		if [ "$color" = "" ]
		then
			codigoError=3
			return $codigoError
		else
			archivo="/lib/plymouth/themes/default.grub"

			case $1 in
				1)			
					variable="menu_color_normal="
				;;
				2)
					variable="menu_color_highlight="
				;;
			esac

			buscar=`grep $variable $archivo`
			if  [ "$buscar" != "" ] #Si al realizar el grep, hemos hallado algo, borramos la línea
			then
				sed -i "/$variable/d" $archivo
			fi
			echo "$variable$color" >> $archivo
			codigoError=0
			return $codigoError
		fi
	else
		codigoError=1
		return $codigoError
	fi
}
