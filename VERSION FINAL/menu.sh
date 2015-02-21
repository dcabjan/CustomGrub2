#!/bin/bash

#Versión utilizada para testeo: Ubuntu 14.04LTS

#ventana del menú principal

. /home/ddd/Escritorio/menus_lib.sh

bucle=true

#Menú principal
while [ $bucle = true ]
do
  opcion=$(zenity --list --print-column="1" --hide-column="1" --height="300" --width="400" --title="Elija una opción" \
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
          2) #Mostramos el menú de personalización
              menuPersonalizar
          ;;
          3)
              ##Llamar a la libreria de funciones
              menuConfiguracion
          ;;
          4)
              echo "Ventana de registro de actividad"
          ;;	
          5)
            #Ventana confirmacion de guardar cambios
          	ventanaConfirm=(`zenity --question --text "¿Esta usted seguro que desea guardar los cambios realizados?"`)
            if [ $? -eq 0 ]
            then
              guardarCambios
            else
              errorCode=3
              error $errorCode
            fi
          ;;
          6)
          	bucle=false
          ;;
          esac
	fi
done
