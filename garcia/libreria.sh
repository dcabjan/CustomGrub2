function perfil_modificar() {
  
  #se abrira el menu principal para empezar a modificar
  zenity --info \
  --text="Ahora se abrirá el menú principal"

}

function perfil_eliminar() {

  #coje lista de directorios del directorio profiles donde estan los usuarios
  opcion=`ls /home/.grubcustom/profiles | zenity --list \
  --column="Elige opcion de perfil"`
  #solicita confirmacion
  zenity --question \
  --text="¿Está seguro de que quiere eliminar?"
  #elimina perfil
  if [ $? = 0 ]
  then
    rmdir /home/.grubcustom/profiles/$opcion
    #mensaje de confirmacion
    zenity --info \
    --text="perfil eliminado correctamente"
  
    else
      zenity --error \
      --text="No se ha eliminado ningun perfil"
  
  fi
  ./perfiles.sh
}

function perfil_crear() {

  #textbox para insertar nuevo perfil
  perfil=`zenity --entry \
  --title="Añadir un perfil nuevo" \
  --text="Escriba el nombre del perfil nuevo:"`
  #crea directorio de perfil si ha sido introducido
  if [ $perfil ]
  then
    mkdir /home/.grubcustom/profiles/$perfil
    #mensaje de confirmacion
    zenity --info \
    --text="perfil creado correctamente"
    else
      zenity --error \
      --text="No se ha creado ningun perfil"
  fi
  ./perfiles.sh
}

function perfil_restaurar() {

  #coje lista de directorios del directorio profiles donde estan los usuarios
  opcion=`ls /home/.grubcustom/profiles | zenity --list \
  --column="Elige opcion de perfil"`
  
  #solicita confirmacion
  zenity --question \
  --text="¿Está seguro de que quiere restaurar el perfil predeterminado?"
  
  if [ $? = 0 ]
  then
    #restaurar del directorio .default los siguientes archivos (copy a directorio original)
    cp /home/.grubcustom/profiles/$opcion/05_debian_theme /etc/grub.d/05_debian_theme
    cp /home/.grubcustom/profiles/$opcion/grub /etc/default/grub
    cp /home/.grubcustom/profiles/$opcion/grub.cfg /boot/grub2/grub.cfg
    cp /home/.grubcustom/profiles/$opcion/40_custom /etc/grub.d/40_custom
  fi
  ./perfiles.sh
}

function perfil_elegir() {

    #solicita confirmacion
  zenity --question \
  --text="¿Está seguro de que quiere restaurar el perfil seleccionado?"
  
  if [ $? = 0 ]
  then
    #restaurar del directorio .default los siguientes archivos (copy a directorio original)
    cp /home/.grubcustom/profiles/.default/05_debian_theme /etc/grub.d/05_debian_theme
    cp /home/.grubcustom/profiles/.default/grub /etc/default/grub
    cp /home/.grubcustom/profiles/.default/grub.cfg /boot/grub2/grub.cfg
    cp /home/.grubcustom/profiles/.default/40_custom /etc/grub.d/40_custom
  fi
  ./perfiles.sh
}