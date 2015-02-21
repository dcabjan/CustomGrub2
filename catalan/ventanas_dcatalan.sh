##Llamar a la libreria de funciones
# . /home/ddd/Escritorio/lib_dcatalan.sh
. /home/ddd/Escritorio/lib_dcatalan.sh

ventanaConfiguracion=`zenity --list --print-column="1" --title="Eliga una opcion" --column="codigo" --column="Nombre" --height="300" --width="480" \
1. "Visibilidad opcion recovery" \
2. "Entrada por defecto de GRUB2" \
3. "Timeout"`
ventanaConfiguracion=`echo $ventanaConfiguracion | cut -d "|" -f 1`
# echo $ventanaConfiguracion
case $ventanaConfiguracion in
  "1.")
    ventanaRecovery=`zenity --list --print-column="1" --title="Eliga una opcion" --column="codigo" --column="Nombre" --height="300" --width="480" \
    1. "Habilitar Recovery" \
    2. "Deshabilitar Recovery"`
    ventanaRecovery=`echo $ventanaRecovery | cut -d "|" -f 1`
    if [ 'x'$ventanaRecovery != 'x' ]
      then
      recoveryMode
      else
	echo "Debe de elegir una opcion!"
    fi
  ;;
  "2.")
    longEntradas=`grep "menuentry '" /boot/grub/grub.cfg -c`
    contador=1
    opcionesEntradas=`sed '150,190d' /boot/grub/grub.cfg | grep "menuentry '" | cut -d "(" -f 1 | tr -d ' '`
    for i in $opcionesEntradas
    do
      i=`echo $i | cut -d "'" -f2`
      resEntrada=$resEntrada$contador". "$i" "
      if [ $contador -eq "1" ]
      then
	let contador=$contador+2
	else
	let contador=$contador+1
      fi
    done
    ventanaEntradaPredeterminada=`zenity --list --column="Codigo" --column="Sistema operativo" --title="Eliga una opcion" --hide-column="1" --height="300" --width="480" \
    $resEntrada`
    case $? in
      0)
      if [ 'x'$ventanaEntradaPredeterminada != 'x' ]
      then
	ventanaEntradaPredeterminada=`echo $ventanaEntradaPredeterminada | cut -d "|" -f 1 | cut -d '.' -f 1`
	entradaPorDefecto "$ventanaEntradaPredeterminada"
	else
	  echo 'Debe de elegir una opcion!'
      fi      
      ;;
      1)
      ##Se ha cerrado la aplicacion. Volver a la pantalla incial
      ;;
      -1)
      ##Ha ocurrido un error...
      ;;
      esac
  ;;
  "3.")
    ventanaTimeout=`zenity --scale --text="Seleccione el tiempo de espera." --value="30" --max-value="60" --min-value="5" --step="5"`
    case $? in
      0)
	timeout $ventanaTimeout
      ;;
      -1)
      ##Volver a la ventana ventana configuracion
      ;;
    esac

  ;;
  *)
  ;;
esac