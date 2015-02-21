function perfilModificar() {
  
  #se abrira el menu principal para empezar a modificar
  ./menu.sh

}

function perfilEliminar() {

  #elimina directorio de perfil
  if [ $? = 0 ]
  then
    rmdir /home/.grubcustom/profiles/$opcion
    #mensaje de confirmacion
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
    #mensaje de confirmacion
    zenity --info \
    --text="perfil creado correctamente"
	#muestra otra vez el menu principal
	./perfiles.sh
  fi

}

function perfilRestaurar() {
  
  if [ $? = 0 ]
  then
    #restaurar del directorio del perfil los siguientes archivos al directorio original
    cp /home/.grubcustom/profiles/$opcion/default.grub /lib/plymouth/themes/default.grub
    cp /home/.grubcustom/profiles/$opcion/grub /etc/default/grub
    cp /home/.grubcustom/profiles/$opcion/grub.cfg /boot/grub2/grub.cfg
	#muestra otra vez el menu principal
	./perfiles.sh
  fi	
}

  

function perfilElegir() {
  
  if [ $? = 0 ]
  then
    #restaurar del directorio .default los siguientes archivos al directorio original
    cp /home/.grubcustom/profiles/.default/default.grub /lib/plymouth/themes/default.grub
    cp /home/.grubcustom/profiles/.default/grub /etc/default/grub
    cp /home/.grubcustom/profiles/.default/grub.cfg /boot/grub2/grub.cfg
	#muestra otra vez el menu principal
	./perfiles.sh
  fi
  
}