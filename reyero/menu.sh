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
		2) #Mostramos el menú de personalización
			opcion=$(zenity --list --print-column="1" --hide-column="1" --title="Elija una opción" \
			--column="Valor" --column="Seleccione una opción" \
		  		"1" \ "Fondo de pantalla" \
				"2" \ "Fuentes" \
				"3" \ "Resolución")

			#Dependiendo de la opción...
			case $opcion in
				1) #Mostramos el menú de Fondo de pantalla
					opcion=$(zenity --list --print-column="1" --hide-column="1" --title="Elija una opción" \
					--column="Valor" --column="Seleccione una opción" \
					  	"1" \ "Seleccionar un color" \
						"2" \ "Seleccionar una imagen")

					case $opcion in
						1)
							echo "Ventana de selección de color"
						;;
						2)
							#Mostramos la ventana de selección de ficheros
							ruta=`zenity --file-selection`

							imgfondo
						;;
						*)
						codigoError=3
						;;
					esac
				;;
				2) #Mostramos el menú de Fuentes
					opcion=$(zenity --list --print-column="1" --hide-column="1" --title="Elija una opción" \
					--column="Valor" --column="Seleccione una opción" \
						"1" \ "Color de entrada" \
						"2" \ "Color de entrada resaltada")

					if [ "$opcion" != "" ] #Si el usuario ha elegido una opción, mostramos el listado de colores
					then					
						#Mostramos una selección de colores
						color=$(zenity --list --print-column="1" --hide-column="1" --title="Elija un color de resaltado" \
						--column="Valor" --column="Seleccione un color" \
						  "yellow/dark-gray" \ "Amarillo / Gris oscuro" \
							"white/black" \ "Blanco / Negro" \
							"cyan/black" \ "Cian / Negro " \
							"light-green/black" \ "Verde claro / Negro" \
						  "black/red" \ "Negro / Rojo" \
						  "yellow/blue" \ "Amarillo / Azul")

						case $opcion in
							1)
								color 1
							;;
							2)
								color 2
							;;
							*)
							codigoError=3
							;;
						esac
					else
						codigoError=3
					fi
				;;
				3) #Mostramos el menú de resoluciones
					#Mostrar la lista de resoluciones disponibles
					listaRes=`listaResoluciones`

					#Se muestra al usuario una lista con todas las resoluciones disponibles
					opcion=`zenity --list --column "Resoluciones" $listaRes`

					resolucion

				;;
				*)
				codigoError=3
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

	#Listado de mensajes de error
	case $codigoError in
		0)
			zenity --info --text "Cambios realizados correctamente."
		;;
		1)
			zenity --error --text "No se guardaron los cambios."
		;;
		2)
			zenity --error --text "Selecciona una imagen válida."
		;;
		3)
			zenity --error --text "Seleccione una opción válida."
		;;
	esac
	
	menu
}

menu
