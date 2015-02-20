#!/bin/bash
#Versión utilizada para testeo: Ubuntu 14.04LTS

#ventana del menú principal

. /home/sad/Escritorio/menus_lib.sh

#
#CAMBIAR RUTA DE ARRIBA POR LA RUTA FINAL DEL USUARIO
#

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