function buscaReemplaza() {
  limpiar=`echo "$1" | tr -d " "`
  test=`grep "$limpiar" "$2" | tr -d " " | cut -d "=" -f 2`
  sed -i "s/$test/$3/g" "$2"
} 

function timeout() {
  archivo="/etc/default/grub"
  string="GRUB_TIMEOUT="
  buscaReemplaza "$string" $archivo "$1"
}

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
	  anadir_almoadilla="#"$buscar
	  sed -i "s/$buscar/$anadir_almoadilla/g" $2
	  ventanaDescOk=`zenity --info --text="Se ha deshabilitado correctamente."`
      fi
      let contador=$contador+1
    done
  done
}

function desdescomentarLinea() {
buscar=`grep $1 $2`
for i in $buscar
do
  contador=1
  while [ $contador -ne 2 ]
  do
    caracter=`expr substr $buscar $contador 1`
    if [ $caracter != "#" ]
    then
      echo "Ya está descomentado!"
      else
	quitarAlmoadilla=`echo $buscar | sed 's/^.//' | tr -d ' '`
	sed -i "s/$buscar/$quitarAlmoadilla/g" $2	
	ventanaDescOk=`zenity --info --text="Se ha habilitado correctamente."`
    fi
    let contador=$contador+1
      
  done
done
}
function recoveryMode ()
{
  archivo="/etc/default/grub"
  string="GRUB_DISABLE_RECOVERY="
  case $ventanaRecovery in
    "1.") ##Caso en el que se elija la opcion "Habilitar recovery"
      desdescomentarLinea $string $archivo
    ;;    
    "2.") ##Caso en el que se elija "Deshabilitar Recovery"
      comentar_linea $string $archivo
    ;;
    *)
    ;;
  esac
}

function entradaPorDefecto ()
{
  archivo="/etc/default/grub"
  string="GRUB_DEFAULT="
  buscaReemplaza $string $archivo "$1"

}

##grep "menuentry '" /boot/grub/grub.cfg -c | cut -d "'" -d 2 --> cuenta las lineas de las entradas de grub2.
#Catalan#
