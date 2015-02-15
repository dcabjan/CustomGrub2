. libreria.sh
 
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
    perfil_crear
  ;;
  
  "Modificar perfil")
    perfil_modificar
  ;;
  
  "Eliminar perfil")
    perfil_eliminar
  ;;  
  
  "Restaurar perfil")
    perfil_restaurar
  ;;
  
  "Elegir perfil")
    perfil_elegir
  ;;


esac