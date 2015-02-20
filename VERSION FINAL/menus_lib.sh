#!/bin/bash

#VENTANAS DE SUBMENÚS
#Ventana del menú - Personalización
#Cargamos la librería de funciones
. /home/sad/Escritorio/lib.sh

function menuPersonalizar () {
  opcion=$(zenity --list --print-column="1" --hide-column="1" --title="Elija una opción" \
              --column="Valor" --column="Seleccione una opción" \
                  "1" \ "Fondo de pantalla" \
                  "2" \ "Fuentes" \
                  "3" \ "Resolución")

  #Dependiendo de la opción...
  case $opcion in
      1) #Mostramos el menú de Fondo de pantalla
          opcion=$(zenity --list --print-column="1" --cancel-label="Atrás" --hide-column="1" --title="Elija una opción" \
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

                  imgfondo $ruta
              ;;
              *)
              codigoError=3
              ;;
          esac
      ;;
      2) #Mostramos el menú de Fuentes
          opcion=$(zenity --list --print-column="1" --cancel-label="Atrás" --hide-column="1" --title="Elija una opción" \
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
  

}

#Ventana del menú - Configuración
function menuConfiguracion () {
  ventana_configuracion=`zenity --list --print-column="1" --title="Eliga una opcion" --column="codigo" --column="Nombre" --height="300" --width="480" \
    1. "Visibilidad opcion recovery" \
    2. "Entrada por defecto de GRUB2" \
    3. "Timeout"`
  	ventana_configuracion=`echo $ventana_configuracion | cut -d "|" -f 1`
  case $ventana_configuracion in
  "1.")
    ventana_recovery=`zenity --list --print-column="1" --title="Eliga una opcion" --column="codigo" --column="Nombre" --height="300" --width="480" \
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
  ventana_entrada_predeterminada=`zenity --list --column="Codigo" --column="Sistema operativo" --title="Eliga una opcion" --hide-column="1" --height="300" --width="480" \
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
  	ventana_timeout=`zenity --scale --text="Seleccione el tiempo de espera." --value="30" --max-value="60" --min-value="5" --step="5"`
  	case $? in
   	 0)
  		timeout $ventana_timeout
     ;;
     1)
      ##Volver a la ventana ventana configuracion
      menuConfiguracion
    ;;
  esac
}

function perfiles () {

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
	
    perfil_crear
  ;;
  
  "Modificar perfil")
  	perfil=`ls /home/.grubcustom/profiles | zenity --list \
	--column="Elige opcion de perfil"`
    perfil_modificar $perfil
  ;;
  
  "Eliminar perfil")
    #coje lista de directorios existentes del directorio profiles donde estan los perfiles
	opcion=`ls /home/.grubcustom/profiles | zenity --list \
	--column="Elige opcion de perfil"`
	#al elegir uno se solicita confirmacion
	zenity --question \
	--text="¿Está seguro de que quiere eliminar?"
	
    perfil_eliminar
  ;;  
  
  "Restaurar perfil")
    #coje lista de directorios existentes del directorio profiles donde estan los usuarios
	opcion=`ls /home/.grubcustom/profiles | zenity --list \
	--column="Elige opcion de perfil"`
  
	#solicita confirmacion
	zenity --question \
	--text="¿Está seguro de que quiere restaurar el perfil predeterminado?"
	
    perfil_restaurar
  ;;
  
  "Elegir perfil")
    #solicita confirmacion
	zenity --question \
	--text="¿Está seguro de que quiere restaurar el perfil seleccionado?"
    perfil_elegir
  ;;

esac

}
