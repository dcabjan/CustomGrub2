#Garcia
#Garcia
#Cabot

function zenityCrearContra(){
	nuevaContra=($(zenity --forms --text="Introduzca el nombre de usuario y la contraseña deseada:" --title="Crear contraseña" width="400" --height="200" --separator=" " \
		--add-entry="Usuario" \
		--add-password="Contraseña" \
		--add-password="Repita contraseña"))
	#comprueba si ambas contraseñas coinciden
	if [ ${nuevaContra[1]} == ${nuevaContra[2]} ]
		#si coinciden modificamos el fichero, mostramos mensaje de que se creó la contraseña y volvemos al menu Gestión de contraseña
		then
		cat >> /etc/grub.d/40_custom <<TXT
set superusers="${nuevaContra[0]}"
password ${nuevaContra[0]} ${nuevaContra[1]}
TXT
		sudo update-grub2
		zenity --info --text="La contraseña ha sido creada."
		zenityGestionContraseña
	#si no coinciden mostramos mensaje de error y volvemos a la ventana de Crear contraseña
	else
		zenity --warning --text="Error. Las contraseñas introducidas no coinciden."
		zenityCrearContra
	fi
}

function zenityModificarContra(){
	modificarContra=($(zenity --forms --text="Introduzca la nueva contraseña:" --title="Modificar contraseña" width="400" --height="200" --separator=" " \
		--add-password="Contraseña" \
		--add-password="Repita contraseña"))
		#comprueba si ambas contraseñas coinciden
		if [ ${modificarContra[0]} == ${modificarContra[1]} ]
		#si coinciden modificamos el fichero, mostramos mensaje de que se creó la contraseña y volvemos al menu Gestión de contraseña
			then
			let linea=`grep -n "set superusers=" /etc/grub.d/40_custom`+1
			echo $linea
		fi
}

function zenityGestionContraseña(){
	menuContra=$(zenity --list --text="Elija una opción:" --title="Gestión de contraseña" --hide-column="1" --width="400" --height="400" \
	 --column="Valor" --column="Opciones" \
	 1 "Crear contraseña" \
	 2 "Modificar contraseña" \
	 3 "Eliminar contraseña")

	case $menuContra in
		"1")
		zenityCrearContra
		;;
		"2")
		zenityModificarContra
		;;
		"3")
		zenityEliminarContra
		;;
	esac
}

#menú principal
function zenityMenuPrincipal(){
	#ventana menú principal
	menuPrincipal=$(zenity --list --text="Elija una opción:" --title="Menú principal" --hide-column="1" --width="400" --height="400" \
		--column="Valor" --column="Opciones" \
		1 "Gestión de contraseña" \
		2 "Personalización" \
		3 "Configuración" \
		4 "Registro de actividad")
	
	case $menuPrincipal in
		"1")
		zenityGestionContraseña
		;;
		"2")
		
		;;
		"3")
		
		;;
		"4")
		
		;;
	esac
}

#Cabot
#Dios
#Dios
#Catalan
#Catalan