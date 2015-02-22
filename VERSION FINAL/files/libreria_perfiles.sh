#Modificar perfil
function perfilModificar() {
  #se abrira el menu principal para empezar a modificar
  perfil=$1
  export perfil
  ./menu.sh
}

function perfilEliminar() {
  #elimina directorio de perfil
  rmdir /home/.customgrub2/profiles/$1
}
function perfilCrear() {
  #crea directorio de perfil si ha sido introducido
  mkdir /home/.customgrub2/profiles/$perfil
}
function perfilElegir() {
    #restaurar del directorio del perfil los siguientes archivos al directorio original
    cp /home/.customgrub2/profiles/$perfil/default.grub /lib/plymouth/themes/default.grub
    cp /home/.customgrub2/profiles/$perfil/grub /etc/default/grub
    cp /home/.customgrub2/profiles/$perfil/grub.cfg /boot/grub2/grub.cfg	
}
function perfilRestaurar() {
    #restaurar del directorio .default los siguientes archivos al directorio original
    cp /home/.customgrub2/profiles/.default/default.grub /lib/plymouth/themes/default.grub
    cp /home/.customgrub2/profiles/.default/grub /etc/default/grub
    cp /home/.customgrub2/profiles/.default/grub.cfg /boot/grub2/grub.cfg
  
}
