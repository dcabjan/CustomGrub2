#!/bin/bash

. /home/sad/Escritorio/lib.sh

#Menú principal
function menu () {
	opcion=$(zenity --list --print-column="1" --hide-column="1" --title="Elija una opción" \
	--column="Valor" --column="Seleccione una opción" \
	  	"1" \ "Gestión de contraseña" \
		"2" \ "Personalización" \
		"3" \ "Configuración" \
		"4" \ "Registro de actividad" \
		"5" \ "Salir")

	case $opcion in
		1)
			echo "Ventana gestor de contraseñas"
		;;
		2)
			opcion=$(zenity --list --print-column="1" --hide-column="1" --title="Elija una opción" \
			--column="Valor" --column="Seleccione una opción" \
		  		"1" \ "Fondo de pantalla" \
				"2" \ "Fuentes" \
				"3" \ "Resolución")

			case $opcion in
				1)
					opcion=$(zenity --list --print-column="1" --hide-column="1" --title="Elija una opción" \
					--column="Valor" --column="Seleccione una opción" \
					  	"1" \ "Seleccionar un color" \
						"2" \ "Seleccionar una imagen")

					case $opcion in
						1)
							echo "Ventana de selección de color"
						;;
						2)
							imgfondo
						;;
					esac
				;;
				2)
					opcion=$(zenity --list --print-column="1" --hide-column="1" --title="Elija una opción" \
					--column="Valor" --column="Seleccione una opción" \
		  				"1" \ "Tamaño de fuente" \
						"2" \ "Color de entrada" \
						"3" \ "Color de entrada resaltada")

					case $opcion in
						1)
							color 1
						;;
						2)
							color 2
						;;
						3)
							color 3
						;;
					esac
				;;
				3)
					resolucion
				;;
			esac
		;;
		3)
			echo "Ventana de configuración"
		;;
		4)
			echo "Ventana de registro de actividad"
		;;
		5)
			exit
		;;
	esac

	menu
}

menu
