#!/bin/bash

#Color opciones seleccionadas

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
	archivo="/lib/plymouth/themes/default.grub"
	variable="menu_color_highlight="

	buscar=`grep $variable $archivo`
	if  [ "$buscar" != "" ] #Si al realizar el grep, hemos hallado algo, borramos la línea
	then
	sed -i "/$variable/d" $archivo
	fi
	echo "$variable$color" >> $archivo
	zenity --info --text "Cambios realizados correctamente."
else
	zenity --error --text "No se guardaron los cambios."
fi

#Lo mismo para menu_color_normal
menu_color_normal=black/light-gray

#Y para color_normal
color_normal=black/light-gray
