#!/bin/bash

#
#Proyecto de ASO. Aplicación para la configuración y personalización de GRUB2
#
#Componentes del grupo:
#David Cabot
#Daniel Catalán
#David García
#Ángel Alberto Reyero
#
#Versión utilizada para testeo: Ubuntu 14.04LTS
#


#Carga de la librería de submenús
. /bin/.customgrub2/menus_lib.sh

bucle=true

#Cargamos el menú de perfiles
perfiles

#Menú principal
while [ $bucle = true ]
do
	opcion=$(zenity --list --print-column="1" --cancel-label="Volver a perfiles" --hide-column="1" --height="300" --width="400" --title="Elija una opción" \
	--column="Valor" --column="Seleccione una opción" \
	"1" \ "Gestión de contraseña" \
	"2" \ "Personalización" \
	"3" \ "Configuración" \
	"4" \ "Registro de actividad" \
	"5" \ "Guardar cambios" \
	"6" \ "Salir")

	if [ $? -eq 1 ]
	then
		perfiles
	else
		case $opcion in
		1)
			#Mostramos el menú de gestión de contraseña
			menuGestionContra

		;;
		2) 
			#Mostramos el menú de personalización
			menuPersonalizar
		;;
		3)
			#Mostramos el menú de configuración
			menuConfiguracion
		;;
		4)
			#Función que muestra el historial de logs, los cuales se podrán visualizar
			echo "Ventana de registro de actividad"
		;;	
		5)
			#Función que guarda los cambios y actualiza el GRUB2. Requiere confirmación
			ventanaConfirm=(`zenity --question --text="¿Esta usted seguro que desea guardar los cambios realizados?"`)
			if [ $? -eq 0 ]
			then
				guardarCambios
			fi
		;;
		6)
			#Si la opción elegida es "Salir", establecemos el bucle a 'false' y se cerrará la aplicación
			bucle=false
		;;
		esac
	fi
done
