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
. /bin/.customgrub2/lib.sh

#muestra menu de perfil
perfiles

bucle=true

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
			registroLog
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

function perfiles() {

#comprueba root
if [ $USER != "root" ]
then
  error 19
  exit
fi
 
#muestra menu con opciones a elegir
opcionperfil=`zenity --list \
 --column="Elige opcion de perfil" \
"Nuevo perfil" \
"Modificar perfil" \
"Eliminar perfil" \
"Elegir perfil" \
"Restaurar perfil"`

if [ $? -eq 1 ]
then
  exit
  
  else
  #segun opcion, ejecutara su funcion
  case $opcionperfil in

    "Nuevo perfil")
      #textbox para insertar nuevo perfil
      perfil=`zenity --entry \
      --title="Añadir un perfil nuevo" \
      --text="Escriba el nombre del perfil nuevo:"`
      if [ $perfil ]
      then
	perfilCrear
	error 10
	perfiles
	else
	  error 1
	  perfiles
	
      fi
    ;;
    
    
    "Modificar perfil")
      perfil=`ls /home/.customgrub2/profiles | zenity --list \
      --column="Elige opcion de perfil"`
      if [ $perfil ]
      then    
	perfilModificar $perfil
	return
      else
	error 3
	perfiles
      fi
    ;;
    
    "Eliminar perfil")
      #coge lista de directorios existentes del directorio profiles donde estan los perfiles
      opcion=`ls /home/.customgrub2/profiles | zenity --list \
      --column="Elige opcion de perfil"`
      if [ $opcion ]
      then    
	#al elegir uno se solicita confirmacion
	zenity --question \
	--text="¿Está seguro de que quiere eliminar?"
	if [ $? = 0 ]
	then
	  perfilEliminar $opcion
	  error 12
	  perfiles
	else
	  perfiles
	fi
      else
	error 3
	perfiles
      fi
    ;;  
    
    "Restaurar perfil")
      #solicita confirmacion
      zenity --question \
      --text="¿Está seguro de que quiere restaurar el perfil predeterminado?"
      if [ $? = 0 ]
      then
	  perfilRestaurar
	  error 14
	  perfiles
      else
	perfiles
      fi
    ;;
    
    "Elegir perfil")
      #coge lista de directorios existentes del directorio profiles donde estan los usuarios
      opcion=`ls /home/.customgrub2/profiles | zenity --list \
      --column="Elige opcion de perfil"`
      if [ $? = 0 ]
      then
	  perfilElegir
	  error 16
	  perfiles
      else
	error 3
	perfiles
      fi
    ;;

  esac
fi

}