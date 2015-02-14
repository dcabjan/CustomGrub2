#!/bin/bash

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

	zenity --info --text "Cambios realizados correctamente."
else
	zenity --error --text "No se guardaron los cambios."
fi
