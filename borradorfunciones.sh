#!/bin/bash

#Function timing: counts from 1 to 100 i 3 seconds (100 * 0.03 = 3)
function timing
{
for i in `seq 1 100`
do
	echo "$i"
	sleep 0.01
done
}

#CHECK SI ERES ROOT, SINO, EJECUTA EL SCRIPT CON SUDO
function rootcheck () {
	if [ $(id -u) != "0" ]
	then
		sudo "$0" "$@"
		exit $?
	fi
}

rootcheck

#PILLAR ULTIMA COSA DE UNA RUTA
ruta=`echo "/home/reyero/porno/xxx/mispeliculas/amor/matematicas/kevinbacon/steam/foto.jpg" | tr '/' ' '`

for i in $ruta
do
 i=$i
done
i=`echo $i | cut -d "." -f 2`
echo $i

hola=`xrandr | sed -n '3,$p'`

echo $hola

cont=1
for i in $hola
do
	res=`echo $hola | cut -d " " -f $cont | tr '' ' \n'`
	aux="$res $aux"	
	let cont=$cont+2
done

zenity --list --column "Resoluciones" $aux
#ls /home/sad/Escritorio/Perfiles | zenity --list --column "Perfiles"
#timing | zenity --progress --title="Probando" --no-cancel --text="Bienvenido al proyecto de ASO" --percentage=0 --auto-close

#ENTRY=$(zenity --password --username)

#primero=`echo $ENTRY | cut -d '|' -f 1`
#segundo=`echo $ENTRY | cut -d '|' -f 2`

#if [ \( "$primero" = "test" \) -a \( "$segundo" = "test2" \) ]
#then
	#zenity --info --title="Bienvenido" --text="Tu usuario es $primero y tu contraseña $segundo"
	#comando=$(zenity --entry --text="Introduce un comando" --title="Comando")
	#zenity --info --title="Comando" --text="El comando es $comando"
	#$comando

#Muestra un listado en forma de checklist con cosas
#prueba=$(zenity --list --print-column="ALL" --title="Elija los fallos que quiere ver" \
#--column="Seleccione una opción" \
#  "1. Cambiar color de fondo" \
#  "2. Cambiar color de fuente" \
#  "3. Cambiar imagen de fondo")

#echo $prueba

#zenity --color-selection
#Almacenamos las cosas en variables
#primero=`echo $prueba | cut -d '|' -f 1`
#segundo=`echo $prueba | cut -d '|' -f 2`
#tercero=`echo $prueba | cut -d '|' -f 3`

#Imprimimos las cosas por pantalla
#echo "El número de fallo es $primero."
#echo "La severidad es $segundo."
#echo "La descripción es $tercero."

#else
	#zenity --warning --title="Error" --text="Usuario o contraseña incorrectas"
#fi
