. libreria_perfiles.sh
 
#muestra menu con opciones a elegir
opcionperfil=`zenity --list \
 --column="Elige opcion de perfil" \
"Nuevo perfil" \
"Modificar perfil" \
"Eliminar perfil" \
"Elegir perfil" \
"Restaurar perfil"`

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
      
      else
	echo "va to mu mal"
      
    fi
  ;;
  
  
  "Modificar perfil")
    perfil=`ls /home/.customgrub2/profiles | zenity --list \
    --column="Elige opcion de perfil"`
    if [ $perfil ]
    then    
      perfilModificar $perfil
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
      fi
    fi
  ;;  
  
  "Restaurar perfil")
    #solicita confirmacion
    zenity --question \
    --text="¿Está seguro de que quiere restaurar el perfil predeterminado?"
    if [ $? = 0 ]
    then
	perfilRestaurar
    fi
  ;;
  
  "Elegir perfil")
    #coge lista de directorios existentes del directorio profiles donde estan los usuarios
    opcion=`ls /home/.customgrub2/profiles | zenity --list \
    --column="Elige opcion de perfil"`
    if [ $? = 0 ]
    then
	perfilElegir
    fi
  ;;


esac