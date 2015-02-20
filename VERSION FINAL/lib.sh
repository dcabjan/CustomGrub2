#Librería.sh
#!/bin/bash
#

#Llamada a librerías de menú
#. /home/sad/Escritorio/lib.sh

#
#IDEA DE REYERO PARA LOS LOGS
#
#En vez de llamar a la función "anadirLog", que escribe directamente sobre el fichero, llamar a una función que vaya montando la super variable que contenga todos los cambios realizados.
#En plan:
#
#function montarVar() {
#	texto="Se ha modificado $1 a $2\n"
#	textoLog=$textoLog$texto
#}
#
#anadirLog() { ---> Al igual que se hacía antes, crearíamos los directorios y ficheros pertinentes en caso de no existir, y escribiríamos toda la megavariable, precedido del nombre del perfil
#    fecha=`date +"%d-%m-%Y"`
#	hora=`date +"%H:%M"`
#    location="/home/.customgrub2/profiles"
#    folder=`ls $location/$fecha`
#  
#    if [ $? -eq 1 ] ##Crea o añade registro log en un archivo.
#    then
#    	mkdir $location/$fecha
#    fi
#    
#    echo -e "En perfil $perfil:\n$textoLog" >> $location/$fecha/$hora
#}
#
#miFuncionDeCambiarColor() {
#	cambioElColor ---> Realizo todo el procedimiento para cambiar el color
#	montaVar "cambiar color" $color  ---> AQUI LLAMAMOS A LA FUNCION PARA MONTAR EL TEXTO Y LE PASAMOS COMO VARIABLES LOS ASPECTOS QUE HEMOS MODIFICADO (EL QUÉ Y A QUÉ VALOR)
#}
#
#Cuando se haga el "Guardar cambios", se procede a copiar los ficheros de GRUB al perfil, se hace el update-grub2 y se escribe la variable $textoLog como log
#FIN DE IDEA DE REYERO
#

#Código Catalán LIB
#
##Funcion que añade lineas a un archivo de registros .log
function anadirLog() {
    fecha=`date +"%d_%m_%Y"`
	hora=`date +"%H_%M"`
    location="/home/.customgrub2/profiles"
    folder=`ls $location/$fecha`
  
    if [ $? -eq 1 ] ##Crea o añade registro log en un archivo.
    then
    	mkdir $location/$fecha
    fi
    
    echo -e "Se ha modificado $1 a $2 en perfil $perfil\n" >> $location/$fecha/$hora
}

##Busca el codigo de error recibido como parametro en una base de datos
function error () {
#Original del programa 
#error=`grep "$1:" "/bin/customgrub2/msg_error" | cut -f 2 -d ":"`

#Para pruebas
  error=`grep "$1:" "/home/sad/Escritorio/msg_error" | cut -f 2 -d ":"`

calc=`expr ${1} % 2` #Realizamos el cálculo para saber si el número de error es par o impar

	if [ $calc -eq 0 ]
	then
		label="--info" #Si es par, se pone la etiqueta info
	else
		label="--error" #Si es impar, se pone la etiqueta error
	fi

	mensaje $label "$error"
}

##reemplaza valores de variables ya definidas a partir de un string $1 y un archivo $2
function busca_reemplaza() {
  limpiar=`echo "$1" | tr -d " "`
  test=`grep "$limpiar" "$2" | tr -d " " | cut -d "=" -f 2`
  sed -i "s/$test/$3/g" "$2"
} 
##Cambia el tiempo de espera del sistema en arrancar.
function timeout() {
  archivo="/etc/default/grub"
  string="GRUB_TIMEOUT="
  busca_reemplaza "$string" $archivo "$1"
  anadirLog "timeout" $1
}
##Comenta lineas añadiendo un #
function comentar_linea() {
  buscar=`grep $1 $2`

  for i in $buscar
  do
    contador=1
    while [ $contador -ne 2 ]
    do
      caracter=`expr substr $buscar $contador 1`
      if [ $caracter = "#" ]
      then
		echo "Ya está comentado!"
	  else
        anadir_almohadilla="#"$buscar
        sed -i "s/$buscar/$anadir_almohadilla/g" $2
        ventana_desc_ok=`zenity --info --text="Se ha deshabilitado correctamente."`
      fi
      let contador=$contador+1
    done
  done
}
#Descomenta la linea comprobando si el primer caracter es #
function descomentar_linea() {
  buscar=`grep $1 $2`
  for i in $buscar
  do
    contador=1
    while [ $contador -ne 2 ]
    do
      caracter=`expr substr $buscar $contador 1`
      if [ $caracter != "#" ]
      then
        echo "¡Ya está descomentado!"
        else
      		quitar_almoadilla=`echo $buscar | sed 's/^.//' | tr -d ' '`
      		sed -i "s/$buscar/$quitar_almoadilla/g" $2	
      		ventana_desc_ok=`zenity --info --text="Se ha habilitado correctamente."`
      fi
      let contador=$contador+1

    done
  done
}
#Habilita o deshabilita el recovery mode
function recovery_mode ()
{
  archivo="/etc/default/grub"
  string="GRUB_DISABLE_RECOVERY="
  case $ventana_recovery in
    "1.") ##Caso en el que se elija la opcion "Habilitar recovery"
      descomentar_linea $string $archivo
      anadirLog "recovery mode" "Habilitado"
    ;;    
    "2.") ##Caso en el que se elija "Deshabilitar Recovery"
      comentar_linea $string $archivo
      anadirLog "recovery mode" "Deshabilitado"
    ;;
    *)
    ;;
  esac
}
##Cambia la entrada por defecto.
function entrada_por_defecto ()
{
  archivo="/etc/default/grub"
  string="GRUB_DEFAULT="
  busca_reemplaza $string $archivo "$1"
  anadirLog "entrada por defecto" $1

}

################################################################################################

#
#Código Reyero
#

#Montamos la lista de las resoluciones disponibles
function listaResoluciones() {
	resoluciones=`xrandr | sed -n '3,$p'`
	cont=1
	for i in $resoluciones
	do
		result=`echo $resoluciones | cut -d " " -f $cont | tr '' ' \n'`
		aux="$result $aux"	
		let cont=$cont+2
	done
	
	echo "$aux"
}

#Resoluciones de pantalla
function resolucion () {
	#Si el usuario ha pulsado en Aceptar, se procede a realizar el cambio
	if [ $? -eq 0 ]
	then
		if [ "$opcion" = "" ]
		then
			codigoError=3
			error $codigoError
		else
			archivo="/etc/default/grub"
			variable="GRUB_GFXMODE="

			buscar=`grep $variable $archivo | tr -d " " | cut -d "=" -f 2`
			sed -i "s/$buscar/$opcion/g" $archivo

			contador=1
			buscarLinea=`grep $variable $archivo`
			while [ $contador -ne 2 ]
			do
				caracter=`expr substr $buscarLinea $contador 1`
				if [ $caracter = "#" ]
				then
					quitarComentario=`echo $buscarLinea | sed 's/^.//' | tr -d ' '`
					sed -i "s/$buscarLinea/$quitarComentario/g" $archivo	
				fi
			let contador=$contador+1
			done
			codigoError=2
			error $codigoError
      anadirLog "resolucion" $opcion
		fi
	else
	codigoError=1
	error $codigoError
	menuPersonalizar
	fi
}

#Imagen de fondo
function imgfondo () {
	archivo="/etc/default/grub"
	variable="GRUB_BACKGROUND="

	#Si el usuario ha pulsado en "Aceptar"
	if [ $? -eq 0 ]
	then
		extension=`echo $1 | tr '/' ' '` #Partimos la ruta en partes

		for ext in $extension
		do
			ext=$ext #En la última vuelta del bucle, nos quedaremos con el nombre del archivo y su extensión
		done

		ext=`echo $ext | cut -d "." -f 2` #Almacenamos la extensión en una variable

		#Comprobamos que la extensión sea válida para GRUB2
		if [ "$ext" != "" ]
		then
			if [ \( $ext = "jpg" \) -o \( $ext = "JPG" \) -o \( $ext = "jpeg" \) -o \( $ext = "JPEG" \) -o \( $ext = "png" \) -o \( $ext = "PNG" \) -o \( $ext = "tga" \) -o \( $ext = "TGA" \) ]
			then
				buscar=`grep $variable $archivo`		
				if  [ "$buscar" != "" ] #Si al realizar el grep, hemos hallado algo, borramos la línea
				then
					sed -i "/$variable/d" $archivo
				fi

				echo "$variable\"$1\"" >> $archivo
				codigoError=2
				error $codigoError
        anadirLog "imagen de fondo" $ruta
			else
				codigoError=5
				error $codigoError
				menuPersonalizar
			fi
		else
			codigoError=1
			error $codigoError
			menuPersonalizar
		fi
	fi
}


#Color de fuente del menú

function color () {
	#Si el usuario ha pulsado en Aceptar, se procede a realizar el cambio
	if [ $? -eq 0 ]
	then
		if [ "$color" = "" ]
		then
			codigoError=3
			error $codigoError
		else
			archivo="/lib/plymouth/themes/default.grub"

			case $1 in
				1)			
					variable="menu_color_normal="
                    texto="color normal"
				;;
				2)
					variable="menu_color_highlight="
                    texto="color resaltado"
				;;
			esac

			buscar=`grep $variable $archivo`
			if  [ "$buscar" != "" ] #Si al realizar el grep, hemos hallado algo, borramos la línea
			then
				sed -i "/$variable/d" $archivo
			fi
			echo "$variable$color" >> $archivo
			codigoError=2
      anadirLog "$texto" $color
			error $codigoError
		fi
	else
		codigoError=1
		error $codigoError
		menuPersonalizar
	fi
}

###############################################################################################################################################
#
#Código García
#
##MENU PRINCIPAL
function perfil_modificar() {
  #se abrira el menu principal para empezar a modificar
  #¿¿¿QUÉ PERFIL???
  perfil=$1
  export perfil
  ./menu.sh
}

function perfil_eliminar() {
  #elimina directorio de perfil
  ##EVALUAR CODIGOS DE ERRORES FUERA
  if [ $? = 0 ]
  then
    rmdir /home/.customgrub2/profiles/$1
    #QUITAR mensaje de confirmacion
    zenity --info \
    --text="perfil eliminado correctamente"
	#muestra otra vez el menu principal
	./perfiles.sh
  fi
}
function perfil_crear() {
  #crea directorio de perfil si ha sido introducido
  if [ $perfil ]
  then
    mkdir /home/.grubcustom/profiles/$perfil
    #QUITAR mensaje de confirmacion
    zenity --info \
    --text="perfil creado correctamente"
	#muestra otra vez el menu principal
	./perfiles.sh
  fi
}
function perfil_elegir() {
  
  if [ $? = 0 ]
  then
    #restaurar del directorio del perfil los siguientes archivos al directorio original
    cp /home/.customgrub2/profiles/$perfil/default.grub /lib/plymouth/themes/default.grub
    cp /home/.customgrub2/profiles/$perfil/grub /etc/default/grub
    cp /home/.customgrub2/profiles/$perfil/grub.cfg /boot/grub2/grub.cfg
	#muestra otra vez el menu principal
	./perfiles.sh
  fi	
}
function perfil_restaurar() {
  
  if [ $? = 0 ]
  then
    #restaurar del directorio .default los siguientes archivos al directorio original
    cp /home/.customgrub2/profiles/.default/default.grub /lib/plymouth/themes/default.grub
    cp /home/.customgrub2/profiles/.default/grub /etc/default/grub
    cp /home/.customgrub2/profiles/.default/grub.cfg /boot/grub2/grub.cfg
	#muestra otra vez el menu principal
	./perfiles.sh
  fi
  
}
