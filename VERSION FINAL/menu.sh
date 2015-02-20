#!/bin/bash
#Versión utilizada para testeo: Ubuntu 14.04LTS

#ventana del menú principal

. /home/sad/Escritorio/menus_lib.sh

#ventana del menú de contraseñas
function menuGestionContra(){
  #muestra la ventana del menú principal de contraseñas
  menuContra=$(zenity --list --cancel-label=Atrás --text="Elija una opción:" --title="Gestión de contraseña" --hide-column="1" --width="400" --height="400" \
   --column="Valor" --column="Opciones" \
   1 "Crear contraseña" \
   2 "Modificar contraseña" \
   3 "Eliminar contraseña")
  #se evalua si el usuario clica en aceptar o atras
  if [ "$?" == 0 ]
    #si hace clic en aceptar
    then
    #elegir submenú si el usuario clica en aceptar y ha seleccionado una opción
    if [ "$menuContra" != "" ]
      then
      #dependiendo del valor devuelto se accede al siguiente submenú
      case $menuContra in
        "1")
        #muestra la ventana de nueva contraseña
        nuevaDatos=($(zenity --forms --cancel-label=Atrás --text="Introduzca el nombre de usuario y la contraseña deseada:" --title="Crear contraseña" width="400" --height="200" --separator=" " \
        --add-entry="Usuario" \
        --add-password="Contraseña" \
        --add-password="Repita contraseña"))
        #se evalua si el usuario clica en aceptar o atras
        if [ "$?" == 0 ]
          #si hace clic en aceptar, continua el proceso
          then
          #comprueba si el usuario ha rellenado todos los campos
          if [ ${#nuevaDatos[*]} -ne 3 ]
          then
          error 7
          menuGestionContra
        #si el usuario ha rellenado todos los campos
        else
          #accedemos a la función que crea la nueva contraseña
          nuevaContra ${nuevaDatos[*]}
        fi
        #si hace clic en atrás, vuelve al menú principal de contraseñas
        else
          menuGestionContra
        fi
        ;;
        "2")
        modificaContra=($(zenity --forms --cancel-label=Atrás --text="Introduzca la nueva contraseña:" --title="Modificar contraseña" width="400" --height="200" --separator=" " \
        --add-password="Contraseña" \
        --add-password="Repita contraseña"))
        #se evalua si el usuario clica en aceptar o atras
        if [ "$?" == 0 ]
          #si hace clic en aceptar, continua el proceso
          then
          modificaContra
        #si hace clic en atrás, vuelve al menú principal de contraseñas
        else
          menuGestionContra
        fi
        ;;
        "3")
        eliminaContra=$(zenity --question --cancel-label=Atrás --title="Eliminar contraseña" \
        --text="¿Confirma que desea eliminar la contraseña actual?")
        #se evalua si el usuario clica en aceptar o atras
        if [ "$?" == 0 ]
          #si hace clic en aceptar, continua el proceso
          then
          eliminaContra
        #si hace clic en atrás, vuelve al menú principal de contraseñas
        else
          menuGestionContra
        fi
        ;;
      esac
    else
      error 3
      menuGestionContra
    fi
  fi
}

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
          	#Copiar los archivos de GRUB a la carpeta del perfil del usuario
            cp /lib/plymouth/themes/default.grub /home/.customgrub2/profiles/$perfil
			cp /etc/default/grub /home/.customgrub2/profiles/$perfil
			cp /boot/grub2/grub.cfg /home/.customgrub2/profiles/$perfil
            #Actualizar el GRUB
            update-grub2                
            ##Añadir a archivo log los cambios realizados. 
          ;;
          6)
          	bucle=false
          ;;
          esac
	fi
done
