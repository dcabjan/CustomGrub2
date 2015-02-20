#!/bin/bash

#
#VENTANAS DE SUBMENÚS
#

#Cargamos la librería de funciones
. /home/sad/Escritorio/lib.sh

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
        nuevaContra=($(zenity --forms --cancel-label=Atrás --text="Introduzca el nombre de usuario y la contraseña deseada:" --title="Crear contraseña" width="400" --height="200" --separator=" " \
        --add-entry="Usuario" \
        --add-password="Contraseña" \
        --add-password="Repita contraseña"))
        #se evalua si el usuario clica en aceptar o atras
        if [ "$?" == 0 ]
          #si hace clic en aceptar, continua el proceso
          then
          nuevaContra
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

#Ventana del menú - Personalización
function menuPersonalizar () {
  opcion=$(zenity --list --print-column="1" --cancel-label="Atrás" --hide-column="1" --height="300" --width="400" --title="Elija una opción" \
              --column="Valor" --column="Seleccione una opción" \
                  "1" \ "Fondo de pantalla" \
                  "2" \ "Fuentes" \
                  "3" \ "Resolución")

codError=$?

if [ "$opcion" != "" ]
then
  #Dependiendo de la opción...
  case $opcion in
      1) #Mostramos el menú de Fondo de pantalla
          opcion=$(zenity --list --print-column="1" --cancel-label="Atrás" --hide-column="1" --height="300" --width="400" --title="Elija una opción" \
          --column="Valor" --column="Seleccione una opción" \
              "1" \ "Seleccionar un color" \
              "2" \ "Seleccionar una imagen")

          codError=$?

          if [ "$opcion" != "" ]
          then
            case $opcion in
                1)
                    echo "Ventana de selección de color"
                ;;
                2)
                    #Mostramos la ventana de selección de ficheros
                    ruta=`zenity --file-selection`

                    imgfondo $ruta
                ;;
            esac
          else if [ $codError -eq 1 ]
          then
            menuPersonalizar
          else
            codigoError=3
            error $codigoError
          fi
          fi
      ;;
      2) #Mostramos el menú de Fuentes
          opcion=$(zenity --list --print-column="1" --cancel-label="Atrás" --hide-column="1" --height="300" --width="400" --title="Elija una opción" \
          --column="Valor" --column="Seleccione una opción" \
              "1" \ "Color de entrada" \
              "2" \ "Color de entrada resaltada")

          codError=$?

          if [ "$opcion" != "" ] #Si el usuario ha elegido una opción, mostramos el listado de colores
          then          
              #Mostramos una selección de colores
              color=$(zenity --list --print-column="1" --cancel-label="Atrás" --hide-column="1" --height="300" --width="400" --title="Elija un color de resaltado" \
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
                    error $codigoError
                  ;;
              esac
          else if [ $codError -eq 1 ]
          then
            menuPersonalizar
          else
            codigoError=3
            error $codigoError
          fi
          fi
      ;;
      3) #Mostramos el menú de resoluciones
          #Mostrar la lista de resoluciones disponibles
          listaRes=`listaResoluciones`

          #Se muestra al usuario una lista con todas las resoluciones disponibles
          opcion=`zenity --list --cancel-label="Atrás" --height="300" --width="400" --column "Resoluciones" $listaRes`

          resolucion

      ;;
  esac
else if [ $codError -eq 1 ]
then
  return
else
  codigoError=3
  error $codigoError
fi
fi

}

#Ventana del menú - Configuración
function menuConfiguracion () {
  ventana_configuracion=`zenity --list --print-column="1" --cancel-label="Atrás" --title="Eliga una opcion" --column="codigo" --column="Nombre" --height="300" --width="400" \
    1. "Visibilidad opcion recovery" \
    2. "Entrada por defecto de GRUB2" \
    3. "Timeout"`
    ventana_configuracion=`echo $ventana_configuracion | cut -d "|" -f 1`
  case $ventana_configuracion in
  "1.")
    ventana_recovery=`zenity --list --print-column="1" --cancel-label="Atrás" --title="Eliga una opcion" --column="codigo" --column="Nombre" --height="300" --width="400" \
  1. "Habilitar Recovery" \
  2. "Deshabilitar Recovery"`
    if [ $? -eq 0 ]
    then
      ventana_recovery=`echo $ventana_recovery | cut -d "|" -f 1`
      if [ 'x'$ventana_recovery != 'x' ]
      then
          recovery_mode
      else
          echo "Debe de elegir una opcion!"
      fi
      else
        menuConfiguracion
    fi
  ;;
  "2.")
    long_entradas=`grep "menuentry '" /boot/grub/grub.cfg -c`
    contador=1
  opciones_entradas=`sed '150,190d' /boot/grub/grub.cfg | grep "menuentry '" | cut -d "(" -f 1 | tr -d ' '`
    for i in $opciones_entradas
    do
     i=`echo $i | cut -d "'" -f2`
     res_entrada=$res_entrada$contador". "$i" "
     if [ $contador -eq "1" ]
     then
      let contador=$contador+2
   else
      let contador=$contador+1
     fi
   done
  ventana_entrada_predeterminada=`zenity --list --column="Codigo" --cancel-label="Atrás" --column="Sistema operativo" --title="Eliga una opcion" --hide-column="1" --height="300" --width="400" \
  $res_entrada`
  case $? in
    0)
    if [ 'x'$ventana_entrada_predeterminada != 'x' ]
    then
      ventana_entrada_predeterminada=`echo $ventana_entrada_predeterminada | cut -d "|" -f 1 | cut -d '.' -f 1`
    entrada_por_defecto "$ventana_entrada_predeterminada"
   else
      echo 'Debe de elegir una opcion!'
    fi      
    ;;
    1)
      ##Volver a la ventana ventana configuracion
      menuConfiguracion
    ;;
    esac
    ;;
  "3.")
    ventana_timeout=`zenity --scale --text="Seleccione el tiempo de espera." --cancel-label="Atrás" --value="30" --max-value="60" --min-value="5" --step="5"`
    case $? in
     0)
      timeout $ventana_timeout
     ;;
     1)
      ##Volver a la ventana ventana configuracion
      menuConfiguracion
    ;;
  esac
;;
esac
}

#Ventana de perfiles
function perfiles () {

#comprobacion de root
if [ $USER != "root" ]; then
#mostrar mensaje error autenticacion
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

#segun opcion, mostrará ventana y ejecutara su funcion
case $opcionperfil in

  "Nuevo perfil")
    #textbox para insertar nuevo perfil
<<<<<<< HEAD
  perfil=`zenity --entry \
  --title="Añadir un perfil nuevo" \
  --text="Escriba el nombre del perfil nuevo:"`
  
    perfil_crear
  ;;
  
  "Modificar perfil")
    perfil=`ls /home/.grubcustom/profiles | zenity --list \
  --column="Elige opcion de perfil"`
    perfil_modificar $perfil
=======
	perfil=`zenity --entry \
	--title="Añadir un perfil nuevo" \
	--text="Escriba el nombre del perfil nuevo:"`
	
	#si se confirma, llama a funcion
	if [ $perfil ]
	then
		perfil_crear
	fi
  ;;
  
  "Modificar perfil")
  	perfil=`ls /home/.grubcustom/profiles | zenity --list \
	--column="Elige opcion de perfil"`
	
	#si se confirma, llama a funcion
	if [ $perfil ]
	then
		perfil_modificar $perfil
	fi
>>>>>>> origin/master
  ;;
  
  "Eliminar perfil")
    #coje lista de directorios existentes del directorio profiles donde estan los perfiles
<<<<<<< HEAD
  opcion=`ls /home/.grubcustom/profiles | zenity --list \
  --column="Elige opcion de perfil"`
  #al elegir uno se solicita confirmacion
  zenity --question \
  --text="¿Está seguro de que quiere eliminar?"
  
    perfil_eliminar
  ;;  
=======
	opcion=`ls /home/.grubcustom/profiles | zenity --list \
	--column="Elige opcion de perfil"`
	
	#al elegir uno se solicita confirmacion
	zenity --question \
	--text="¿Está seguro de que quiere eliminar?"
	
	#si se confirma, llama a funcion
	if [ $? -eq 0 ]
	then
		perfil_eliminar
	fi
  ;; 
>>>>>>> origin/master
  
  "Elegir perfil")
    #coje lista de directorios existentes del directorio profiles donde estan los usuarios
  opcion=`ls /home/.grubcustom/profiles | zenity --list \
  --column="Elige opcion de perfil"`
  
  #solicita confirmacion
  zenity --question \
  --text="¿Está seguro de que quiere restaurar el perfil predeterminado?"
  
<<<<<<< HEAD
    perfil_restaurar
=======
	#solicita confirmacion
	zenity --question \
	--text="¿Está seguro de que quiere restaurar el perfil predeterminado?"
	
	#si se confirma, llama a funcion
	if [ $? -eq 0 ]
	then
		perfil_elegir
	fi
>>>>>>> origin/master
  ;;
  
  "Restaurar perfil")
    #solicita confirmacion
<<<<<<< HEAD
  zenity --question \
  --text="¿Está seguro de que quiere restaurar el perfil seleccionado?"
    perfil_elegir
=======
	zenity --question \
	--text="¿Está seguro de que quiere restaurar el perfil seleccionado?"
	
	#si se confirma, llama a funcion
    if [ $? -eq 0 ]
	then
		perfil_restaurar
	fi
>>>>>>> origin/master
  ;;

esac

}
