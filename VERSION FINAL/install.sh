##Instalador de archivo y directorios necesarios para la funcionalidad de la herramienta
###Creacion de carpetas
mkdir -p /home/.customgrub2/{profiles/.default,logs}
mkdir /bin/.customgrub2
cp /boot/grub/grub.cfg /etc/default/grub /lib/plymouth/themes/default.grub /home/.customgrub2/profiles/.default
##Copia ficheros desde carpeta al directorio que pertenecen.
#cp files/*.* /bin/.grubcustom2
cp /home/sad/Escritorio/install/*.* /bin/.customgrub2

##Añadir un alias para ejecutar el script

sed -i "/customgrub2/d" ~/.bashrc

echo "alias customgrub2='/bin/.customgrub2/menu.sh'" >> ~/.bashrc
source ~/.bashrc
