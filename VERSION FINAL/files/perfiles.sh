. libreria_perfiles.sh
. lib.sh
. menus_lib.sh

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

if [ $? -eq 0 ]
then
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
	./perfiles.sh
	else
	  error 1
	  ./perfiles.sh
	
      fi
    ;;
    
    
    "Modificar perfil")
      perfil=`ls /home/.customgrub2/profiles | zenity --list \
      --column="Elige opcion de perfil"`
      if [ $perfil ]
      then    
	perfilModificar $perfil
      else
	error 3
	./perfiles.sh
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
	  ./perfiles.sh
	else
	  ./perfiles.sh
	fi
      else
	error 3
	./perfiles.sh
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
	  ./perfiles.sh
      else
	./perfiles.sh
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
	  ./perfiles.sh
      else
	error 3
	./perfiles.sh
      fi
    ;;


  esac
  
  else
  exit
fi