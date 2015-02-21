#!/bin/bash
#

#
#Librería de funciones
#

##Busca el codigo de error recibido como parametro en una base de datos
function error () {

#Utilizamos una expresión regular para buscar en la base de datos de códigos de error/información
error=`grep "^${1}:" "/bin/.customgrub2/msg_error" | cut -f 2 -d ":"`

calc=`expr ${1} % 2` #Realizamos el cálculo para saber si el número de error es par o impar

	if [ $calc -eq 0 ]
	then
		label="--info" #Si es par, se pone la etiqueta info
	else
		label="--error" #Si es impar, se pone la etiqueta error
	fi

	mensaje $label "$error"
}

#Realiza un guardado de los cambios realizados
function guardarCambios () {
  #Copiar los archivos de GRUB a la carpeta del perfil del usuario
  cp /lib/plymouth/themes/default.grub /home/.customgrub2/profiles/$perfil
  cp /etc/default/grub /home/.customgrub2/profiles/$perfil
  cp /boot/grub/grub.cfg /home/.customgrub2/profiles/$perfil
  
  #Actualizar el GRUB
  update-grub2                
  ##Añadir a archivo log los cambios realizados. 
}

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

#funciones para la opción de crear nueva contraseña
function nuevaContra(){
	datos=($@)
	#comprueba si ambas contraseñas coinciden
	if [ ${datos[1]} == ${datos[2]} ]
		#si coinciden modificamos el fichero
		then
		#creamos un fichero temporal con la contraseña
		cat > temp <<TEMPNEW
${datos[1]}
${datos[1]}

TEMPNEW
		#encriptamos la contraseña
		encrypt=(`grub-mkpasswd-pbkdf2 < temp`)
		#escribimos el código en el fichero para crear la contraseña
		cat >> /etc/grub.d/40_custom <<NEW
set superusers="${datos[0]}"
password ${datos[0]} ${encrypt[12]}
NEW
		#comprobamos si la acción de escritura ha ido bien
		if [ $? -eq 0 ]
			#si ha ido bien
			then
			#volvemos a generar el fichero de grub
			#!!!!!!!!!!!!!!!!!ACTIVAR!!!!!!!!!!!!!!!!!!!sudo update-grub2
			#eliminamos el fichero temporal
			rm temp
			#mostramos mensaje de que la contraseña se ha creado correctamente
			error 4
			menuGestionContra
		#si la acción de escritura no ha ido bien
		else
			error 9
			menuGestionContra
		fi
	#si las contraseñas no coinciden mostramos mensaje de error
	else
		error 4
		menuGestionContra
	fi
}

#funcion para la opción de modificar una contraseña existente
function modificaContra(){
	datos=($@)
	#comprueba si ambas contraseñas coinciden
	if [ ${datos[0]} == ${datos[1]} ]
		#si coinciden modificamos el fichero
		then
		#creamos un fichero temporal con la contraseña
		cat > temp <<TEMPMOD
${datos[0]}
${datos[0]}

TEMPMOD
		#encriptamos la contraseña
		encrypt=(`grub-mkpasswd-pbkdf2 < temp`)
		#buscamos la línea a modificar
		linea=($(grep -n "set superusers=" /etc/grub.d/40_custom | tr ":" " " | tr "\"" " "))
		user=${linea[3]}
		#sustituimos el string que contiene la contraseña
		sed -i "s/^password $user.*/password $user ${encrypt[12]}/" /etc/grub.d/40_custom
		#comprobamos si la acción de sustitución ha ido bien
		if [ $? -eq 0 ]
			#si ha ido bien
			then
			#volvemos a generar el fichero de grub
			#!!!!!!!!!!!!!!!!!ACTIVAR!!!!!!!!!!!!!!!!!!!sudo update-grub2
			#eliminamos el fichero temporal
			rm temp
			#mostramos mensaje de que la contraseña se ha modificado correctamente
			error 8
			menuGestionContra
		#si la acción de sustitución no ha ido bien
		else
			error 9
			menuGestionContra
		fi
	#si las contraseñas no coinciden mostramos mensaje de error
	else
		error 4
		menuGestionContra
	fi
}

#funcion para la opción de eliminar una contraseña existente
function eliminaContra(){
	#buscamos las líneas a eliminar	
	linea=`grep -n "set superusers=" /etc/grub.d/40_custom | cut -f1 -d:`
	#eliminamos las líneas dedicadas a la contraseña de grub
	sed -i "${linea},+2d" "/etc/grub.d/40_custom"
	#comprobamos si la acción de eliminación ha ido bien
	if [ $? -eq 0 ]
		#si ha ido bien
		then
		#volvemos a generar el fichero de grub
		#!!!!!!!!!!!!!!!!!ACTIVAR!!!!!!!!!!!!!!!!!!!sudo update-grub2
		#mostramos mensaje de que la contraseña se ha eliminado correctamente
		error 6
		menuGestionContra
	else
		error 15
		menuGestionContra
	fi
}

#funcion para comprobar si ya existe una contraseña
function existeContra(){
	#buscamos la cadena para saber si ya existe una contraseña establecida
	exists=`grep "set superusers=" /etc/grub.d/40_custom`
	#comprobamos el valor devuelto
	if [ "$exists" == "" ]
		#si existe devolvemos 0
		then
		echo 0
	#si no existe devolvemos 1
	else
		echo 1
	fi
}

##reemplaza valores de variables ya definidas a partir de un string $1 y un archivo $2
function buscaReemplaza() {
  limpiar=`echo "$1" | tr -d " "`
  test=`grep "$limpiar" "$2" | tr -d " " | cut -d "=" -f 2`
  sed -i "s/$test/$3/g" "$2"
} 

##Cambia el tiempo de espera del sistema en arrancar.
function timeout() {
  archivo="/etc/default/grub"
  string="GRUB_TIMEOUT="
  buscaReemplaza "$string" $archivo "$1"
  #anadirLog "timeout" $1
}

##Comenta lineas añadiendo un #
function comentarLinea() {
  buscar=`grep $1 $2`

  for i in $buscar
  do
    contador=1
    while [ $contador -ne 2 ]
    do
      caracter=`expr substr $buscar $contador 1`
      if [ $caracter != "#" ]
      then
        anadirAlmohadilla="#"$buscar
        sed -i "s/$buscar/$anadirAlmohadilla/g" $2
        ventanaDescOk=`zenity --info --text="Se ha deshabilitado correctamente."`
      fi
      let contador=$contador+1
    done
  done
}

#Descomenta la linea comprobando si el primer caracter es #
function descomentarLinea() {
  buscar=`grep $1 $2`
  for i in $buscar
  do
    contador=1
    while [ $contador -ne 2 ]
    do
      caracter=`expr substr $buscar $contador 1`
      if [ $caracter = "#" ]
      then
       		quitarAlmoadilla=`echo $buscar | sed 's/^.//' | tr -d ' '`
      		sed -i "s/$buscar/$quitarAlmoadilla/g" $2	
      		ventanaDescOk=`zenity --info --text="Se ha habilitado correctamente."`
      fi
      let contador=$contador+1
    done
  done
}

#Habilita o deshabilita el recovery mode
function recoveryMode () {
  archivo="/etc/default/grub"
  string="GRUB_DISABLE_RECOVERY="
  case $ventanaRecovery in
    "1.") ##Caso en el que se elija la opcion "Habilitar recovery"
      descomentarLinea $string $archivo
      #anadirLog "recovery mode" "Habilitado"
    ;;    
    "2.") ##Caso en el que se elija "Deshabilitar Recovery"
      comentarLinea $string $archivo
      #anadirLog "recovery mode" "Deshabilitado"
    ;;
  esac
}

##Cambia la entrada por defecto.
function entradaPorDefecto () {
  archivo="/etc/default/grub"
  string="GRUB_DEFAULT="
  buscaReemplaza $string $archivo "$1"
  #anadirLog "entrada por defecto" $1
}

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
			#anadirLog "resolucion" $opcion
		fi
	else
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
				#anadirLog "imagen de fondo" $ruta
			else
				codigoError=5
				error $codigoError
				menuPersonalizar
			fi
		else
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
			#anadirLog "$texto" $color
			error $codigoError
		fi
	else
		menuPersonalizar
	fi
}


#Modificar perfil
function perfilModificar() {
  #se abrira el menu principal para empezar a modificar
  perfil=$1
  export perfil
  ./menu.sh
}

function perfilEliminar() {
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
function perfilCrear() {
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
function perfilElegir() {
  
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
function perfilRestaurar() {
  
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
