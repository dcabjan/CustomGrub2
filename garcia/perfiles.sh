#llamada a librerias necesitadas
. libreria_perfiles.sh
 
#muestra menu con opciones a elegir
opcionperfil=`zenity --list \
 --column="Elige opcion de perfil" \
"Nuevo perfil" \
"Modificar perfil" \
"Eliminar perfil" \
"Elegir perfil" \
"Restaurar perfil"`

#segun opcion, mostrará ventana y ejecutara su funcion
case $opcionperfil in

  "Nuevo perfil")
    #textbox para insertar nuevo perfil
	perfil=`zenity --entry \
	--title="Añadir un perfil nuevo" \
	--text="Escriba el nombre del perfil nuevo:"`
	
    perfilCrear
  ;;
  
  "Modificar perfil")
    perfilModificar
  ;;
  
  "Eliminar perfil")
    #coje lista de directorios existentes del directorio profiles donde estan los perfiles
	opcion=`ls /home/.grubcustom/profiles | zenity --list \
	--column="Elige opcion de perfil"`
	#al elegir uno se solicita confirmacion
	zenity --question \
	--text="¿Está seguro de que quiere eliminar?"
	
    perfilEliminar
  ;;  
  
  "Restaurar perfil")
    #coje lista de directorios existentes del directorio profiles donde estan los usuarios
	opcion=`ls /home/.grubcustom/profiles | zenity --list \
	--column="Elige opcion de perfil"`
  
	#solicita confirmacion
	zenity --question \
	--text="¿Está seguro de que quiere restaurar el perfil predeterminado?"
	
    perfilRestaurar
  ;;
  
  "Elegir perfil")
    #solicita confirmacion
	zenity --question \
	--text="¿Está seguro de que quiere restaurar el perfil seleccionado?"
	
    perfilElegir
  ;;

esac