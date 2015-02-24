#!/bin/bash

#
#Ventanas de submenús
#


#Cargamos la librería de funciones
. /bin/.customgrub2/lib.sh

#Función que crea las ventanas con los mensajes de error/información
function mensajeError() {
	zenity $1 --text "$2"
}

#Ventana del menú de contraseñas
function menuGestionContra(){  
  #Muestra la ventana del menú principal de contraseñas
  menuContra=$(zenity --list --cancel-label=Atrás --text="Elija una opción:" --title="Gestión de contraseña" --hide-column="1" --width="400" --height="400" \
   --column="Valor" --column="Opciones" \
   1 "Crear contraseña" \
   2 "Modificar contraseña" \
   3 "Eliminar contraseña")
  #se evalúa si el usuario clica en aceptar o atrás
  if [ "$?" == 0 ]
    #si hace clic en aceptar
    then
    #elegir submenú si el usuario clica en aceptar y ha seleccionado una opción
    if [ "$menuContra" != "" ]
      then
      #comprobamos si ya existe una contraseña
      passExist=$(existeContra)
      #dependiendo del valor devuelto se accede al siguiente submenú
      case $menuContra in
        "1")
        #evaluamos si existe o no una contraseña previamente
        if [ $passExist -eq 0 ]
          #si no existe una contraseña previamente
          then
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
              #si no los ha rellenado todos muestra mensaje de error
              then
              mensaje 7
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
        #si existe una contraseña previamente un mensaje de error
        else
          mensaje 11
          menuGestionContra
        fi
      ;;
      "2")
      #evaluamos si existe o no una contraseña previamente
      if [ $passExist -eq 1 ]
        #si existe una contraseña previamente
        then
        #muestra la ventana de modificar contraseña
        modificaDatos=($(zenity --forms --cancel-label=Atrás --text="Introduzca la nueva contraseña:" --title="Modificar contraseña" width="400" --height="200" --separator=" " \
        --add-password="Contraseña" \
        --add-password="Repita contraseña"))
        #se evalua si el usuario clica en aceptar o atras
        if [ "$?" == 0 ]
          #si hace clic en aceptar, continua el proceso
          then
          #comprueba si el usuario ha rellenado todos los campos
          if [ ${#modificaDatos[*]} -ne 2 ]
            #si no los ha rellenado todos muestra mensaje de error
            then
            mensaje 7
            menuGestionContra
          #si el usuario ha rellenado todos los campos
          else
            #accedemos a la función que crea la nueva contraseña
            modificaContra ${modificaDatos[*]}
          fi
        #si hace clic en atrás, vuelve al menú principal de contraseñas
        else
          menuGestionContra
        fi
      #si no existe una contraseña mostramos un mensaje de error
      else
        mensaje 13
        menuGestionContra
      fi
      ;;
      "3")
      #evaluamos si existe o no una contraseña previamente
      if [ $passExist -eq 1 ]
        then
        #muestra la ventana de nueva contraseña
        eliminaContra=$(zenity --question --cancel-label=Atrás --title="Eliminar contraseña" \
        --text="¿Confirma que desea eliminar la contraseña actual?")
        #se evalua si el usuario clica en aceptar o atras
        if [ "$?" == 0 ]
          #si hace clic en aceptar, continua el proceso
          then
          #evaluamos si existe o no una contraseña previamente
            eliminaContra
        #si hace clic en atrás, vuelve al menú principal de contraseñas
        else
          menuGestionContra
        fi
      else
        mensaje 13
        menuGestionContra
      fi
      ;;
    esac
  else
    mensaje 3
    menuGestionContra
  fi
fi
}

#Ventana del menú de personalización
function menuPersonalizar () {
	opcion=$(zenity --list --print-column="1" --cancel-label="Atrás" --hide-column="1" --height="300" --width="400" --title="Elija una opción" \
    --column="Valor" --column="Seleccione una opción" \
    "1" \ "Fondo de pantalla" \
    "2" \ "Fuentes" \
    "3" \ "Resolución")

	codError=$?

	#Si la opción no es vacía
	if [ "$opcion" != "" ]
	  then
	  #Dependiendo de la opción...
	  case $opcion in
		  1) #Mostramos el menú de Fondo de pantalla
			opcion=$(zenity --list --print-column="1" --cancel-label="Atrás" --hide-column="1" --height="300" --width="400" --title="Elija una opción" \
			  --column="Valor" --column="Seleccione una opción" \
			  "1" \ "Seleccionar un color" \
			  "2" \ "Seleccionar una imagen" \
				"3" \ "Quitar imagen")

			codError=$?

			#Si la opción no es vacía
			if [ "$opcion" != "" ]
			then
				case $opcion in
				1)
					ventanaConfirm=(`zenity --question --text="Esta opción deshabilitará la imagen, si la hubiese, ¿desea continuar?"`)
					if [ $? -ne 0 ]
					then
						menuPersonalizar
					fi

					#Mostramos la ventana de selección de color de fondo
				  	color=$(zenity --list --print-column="1" --cancel-label="Atrás" --hide-column="1" --height="300" --width="400" --title="Elija un color de resaltado" \
					--column="Valor" --column="Seleccione un color (fuente/fondo)" \
					"yellow/dark-gray" \ "Amarillo / Gris oscuro" \
					"white/black" \ "Blanco / Negro" \
					"cyan/black" \ "Cian / Negro " \
					"light-green/black" \ "Verde claro / Negro" \
					"black/red" \ "Negro / Rojo" \
					"yellow/blue" \ "Amarillo / Azul")


					color 3
				;;
				2)
					#Mostramos la ventana de selección de ficheros
					ruta=`zenity --file-selection`

					imgfondo $ruta
				;;
				3)
					ventanaConfirm=(`zenity --question --text="¿Esta usted seguro que desea quitar la imagen actual?"`)
					if [ $? -eq 0 ]
					then
						quitarImagen

					else
						menuPersonalizar
					fi
				;;
				esac
			else if [ $codError -eq 1 ]
				then
					menuPersonalizar
				else
					codigoError=3
					mensaje $codigoError
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
				    --column="Valor" --column="Seleccione un color (fuente/fondo)" \
				    "yellow/dark-gray" \ "Amarillo / Gris oscuro" \
				    "white/black" \ "Blanco / Negro" \
				    "cyan/black" \ "Cian / Negro " \
				    "light-green/black" \ "Verde claro / Negro" \
				    "black/red" \ "Negro / Rojo" \
				    "yellow/blue" \ "Amarillo / Azul")

					#Dependiendo de la opción
					case $opcion in
					1)
						color 1
					;;
					2)
						color 2
					;;
					*)
						codigoError=3
						mensaje $codigoError
					;;
					esac
				else if [ $codError -eq 1 ]
					then
					 	menuPersonalizar
					else
						codigoError=3
						mensaje $codigoError
					fi
				fi
			;;
			3) #Mostramos el menú de resoluciones

		      #Mostrar la lista de resoluciones disponibles
		      listaRes=`listaResoluciones`

		      #Se muestra al usuario una lista con todas las resoluciones disponibles
          opcion=$(zenity --entry --cancel-label="Atrás" --height="300" --width="400" --title="Resoluciones" --text="Por favor, elija una resolución" $listaRes)

		      resolucion

			;;
		esac
	else if [ $codError -eq 1 ] #Si el código de error es 1, el usuario ha clicado en "Atrás"
		then
			return
		else #Si ninguna de las anteriores es cierta, el usuario no ha seleccionado ninguna opción y ha pulsado en "Aceptar", por lo que mostramos un error
			codigoError=3
			mensaje $codigoError
		fi
	fi
}

#Ventana del menú de configuración
function menuConfiguracion () {
	ventanaConfiguracion=`zenity --list --print-column="1" --cancel-label="Atrás" --title="Eliga una opcion" --column="codigo" --column="Nombre" --height="300" --width="400" --hide-column="1" \
	1. "Visibilidad opcion recovery" \
	2. "Entrada por defecto de GRUB2" \
	3. "Timeout"`
	if [ $? -eq 0 ]
	then
		if [ 'x'$ventanaConfiguracion != 'x' ]
		then
		#Separamos cogiendo el codigo del campo oculto (codigo), ya que, el programa devuelve valores como 1.|1
		ventanaConfiguracion=`echo $ventanaConfiguracion | cut -d "|" -f 1`
		#Evaluamos la opcion elegida por el usuario.
		case $ventanaConfiguracion in
		"1.")
			#Menú opcion recovery
			ventanaRecovery=`zenity --list --print-column="1" --cancel-label="Atrás" --title="Eliga una opcion" --column="codigo" --column="Nombre" --height="300" --width="400" --hide-column="1" \
			1. "Habilitar Recovery" \
			2. "Deshabilitar Recovery"`
			#Si ha elegido una opcion y ha dado a aceptar
			if [ $? -eq 0 ]
			then
				#evaluar la opcion elegida por el usuario.
				ventanaRecovery=`echo $ventanaRecovery | cut -d "|" -f 1`
				#si ha elegido una
				if [ 'x'$ventanaRecovery != 'x' ]
				then
				  recoveryMode
				else
					codError=3
					mensaje $codError
					ventanaConfiguracion
				fi
			#Si ha dado a cancelar vuelve al menu de configuracion
			else
			  menuConfiguracion
			fi
		;;
	    #Menu entrada por defecto
		"2.")
			#Cuenta cuantos sistemas operativos se muestran en lista de grub
			longEntradas=`grep "menuentry '" /boot/grub/grub.cfg -c`
			contador=1
			#Localizamos las lineas de manea dinamica de submenu "Opciones avanzadas"
			primerString=`grep -n "submenu" /boot/grub/grub.cfg | cut -d ":" -f1`
			segundoString=`grep -n "END /etc/grub.d/10_linux" /boot/grub/grub.cfg | cut -d ":" -f1`
			#se busca menuentry excluyendo aquellas lineas en las cuales forman parte de un submenú
			opcionesEntradas=`sed "$primerString"",""${segundoString}d" /boot/grub/grub.cfg | grep "menuentry '" | cut -d "(" -f 1 | tr -d ' '`
			for i in $opcionesEntradas
			do
				#Cogemos el nombre de cada opcion que viene en la lista de grub y las metemos en una variable
				i=`echo $i | cut -d "'" -f2`
				resEntrada=$resEntrada$contador". "$i" "
				#Para que no salga "Opciones avanzadas" haremos un salto mas sumando el contador a +1 cuando valga 1
				if [ $contador -eq "1" ]
				then
					let contador=$contador+2
				else
					#En caso de que el contador no valga 1 sumara 1 mas
					let contador=$contador+1
				fi
			done
			#Mostramos los diferentes sistemas operativos que el usuario puede elegir mediante una lista.
			ventanaEntradaPredeterminada=`zenity --list --column="Codigo" --cancel-label="Atrás" --column="Sistema operativo" --hide-column="1" --title="Elija una opcion" --hide-column="1" --height="300" --width="400" \
			$resEntrada`
			#Controlamos el error que devuelve en una variable.
			ok=$?
			#Limpiamos la variable
			resEntrada=""
			#Evaluamos el codigo de error de salida
			case $ok in
			0)
				#Limpiamos codido de error y lo pasamos a funcion de sustitucion de entrada predeterminada
				if [ 'x'$ventanaEntradaPredeterminada != 'x' ]
				then
					ventanaEntradaPredeterminada=`echo $ventanaEntradaPredeterminada | cut -d "|" -f 1 | cut -d '.' -f 1`
				    let ventanaEntradaPredeterminada=$ventanaEntradaPredeterminada-1
					entradaPorDefecto "$ventanaEntradaPredeterminada"
					codError=2
					mensaje $codError
				else
					##En el caso de que no se elija opcion error vale 3 y se pasará como parametro a funcion error
					codError=3
					mensaje $codError
				fi      
			;;
			1)
				##Volver a la ventana ventana configuracion
				menuConfiguracion
			;;
			esac
	    ;;
		"3.")
			value=`grep "GRUB_TIMEOUT=" "/etc/default/grub" | cut -d "=" -f2`
			echo $value
			#Menu timeout
			ventanaTimeout=`zenity --scale --text="Seleccione el tiempo de espera." --cancel-label="Atrás" --value="$value" --max-value="60" --min-value="5" --step="5"`
			case $? in
			0)
				#Si da a aceptar procede a cambiar el valor en grub
				timeout $ventanaTimeout
				codError=2
				mensaje $codError
			;;
			1)
				##Volver a la ventana ventana configuracion
				menuConfiguracion
			;;
			esac
		;;
	  esac
	else
		codError=3
		mensaje $codError
	fi
	fi
}

#Ventana para mostrar los registros LOG
function registroLog () {
	#Mostrar la lista de LOGS disponibles
	listaLogs=`listaLogs`

	#Se muestra al usuario una lista con todas las resoluciones disponibles
	opcion=$(zenity --entry --cancel-label="Atrás" --height="300" --width="400" --title="Historial de Logs" --text="Por favor, elija un log" $listaLogs)

	if [ $opcion != "" ]
	then
		abrirLog $opcion
	else
		return
	fi
}


function perfiles() {

#comprueba root, en caso de que no sea sale de la aplicacion
if [ $USER != "root" ]
then
  mensaje 19
  exit
fi
 
#muestra menu con opciones a elegir
opcionperfil=`zenity --list \
 --column="Elige opcion de perfil" --height="300" --width="400" --cancel-label="Salir" \
"Nuevo perfil" \
"Modificar perfil" \
"Eliminar perfil" \
"Elegir perfil" \
"Restaurar perfil"`

#si el resultado es 1(error) sale de la aplicacion
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
      #comprueba que no se ha introducido valor vacio
      if [ $perfil != "" ]
      then
	#comprueba que el usuario no existe
	perfilesexistentes=`ls /home/.customgrub2/profiles`
	for i in $perfilesexistentes
	do
	  if [ $i = $perfil ]
	  then
	    resultado=1
	  else
	    resultado=0
	    continue
	  fi
	done
	#si el usuario existe muestra error y vuelve a menu perfiles
	if [ $resultado -eq 1 ]
	  then
	    mensaje 29
	    perfiles
	  else
	    #si no existe se crea el perfil
	    perfilCrear
	    mensaje 10
	    perfiles	    
	fi
	
      else
	# si se ha introducido valor vacio muestra error y vuelve a menu perfiles
	mensaje 1
	perfiles
      fi
    ;;
    
    
    "Modificar perfil")
      #muestra perfiles existentes
      perfil=`ls /home/.customgrub2/profiles | zenity --list \
      --column="Elige opcion de perfil"`
      #comprueba que un perfil ha sido elegido
      if [ $perfil ]
      then    
	#llama a menu modificar
	perfilModificar $perfil
	return
      else
	#muestra error de perfil no elegido
	mensaje 3
	perfiles
      fi
    ;;
    
    "Eliminar perfil")
      #coge lista de directorios existentes del directorio profiles donde estan los perfiles
      opcion=`ls /home/.customgrub2/profiles | zenity --list \
      --column="Elige opcion de perfil"`
      #comprueba si se ha elegido opcion
      if [ $opcion ]
      then    
	#al elegir uno se solicita confirmacion
	zenity --question \
	--text="¿Está seguro de que quiere eliminar?"
	#en caso afirmativo elimina, en caso negativo muestra error
	if [ $? = 0 ]
	then
	  perfilEliminar $opcion
	  mensaje 12
	  perfiles
	else
	  perfiles
	fi
      else
	#muestra error de no haber elegido opcion
	mensaje 3
	perfiles
      fi
    ;;  
    
    "Restaurar perfil")
      #solicita confirmacion
      zenity --question \
      --text="¿Está seguro de que quiere restaurar el perfil predeterminado?"
      #en caso afirmativo se ejecuta la funcion, en caso negativo vuelve a menu perfiles
      if [ $? = 0 ]
      then
	  perfilRestaurar
	  mensaje 14
	  perfiles
      else
	perfiles
      fi
    ;;
    
    "Elegir perfil")
      #coge lista de directorios existentes del directorio profiles donde estan los usuarios
      opcion=`ls /home/.customgrub2/profiles | zenity --list \
      --column="Elige opcion de perfil"`
      #en caso afirmativo ejecuta funcion, en caso negativo vuelve a menu perfiles
      if [ $? = 0 ]
      then
	  perfilElegir
	  mensaje 16
	  perfiles
      else
	mensaje 3
	perfiles
      fi
    ;;

  esac
fi

}