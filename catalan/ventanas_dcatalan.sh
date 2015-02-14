##Llamar a la libreria de funciones
# . /home/ddd/Escritorio/lib_dcatalan.sh
. /home/ddd/Escritorio/lib_dcatalan.sh

ventana_configuracion=`zenity --list --print-column="1" --title="Eliga una opcion" --column="codigo" --column="Nombre" --height="300" --width="480" \
1. "Visibilidad opcion recovery" \
2. "Entrada por defecto de GRUB2" \
3. "Timeout"`
ventana_configuracion=`echo $ventana_configuracion | cut -d "|" -f 1`
# echo $ventana_configuracion
case $ventana_configuracion in
  "1.")
    ventana_recovery=`zenity --list --print-column="1" --title="Eliga una opcion" --column="codigo" --column="Nombre" --height="300" --width="480" \
    1. "Habilitar Recovery" \
    2. "Deshabilitar Recovery"`
    ventana_recovery=`echo $ventana_recovery | cut -d "|" -f 1`
    if [ 'x'$ventana_recovery != 'x' ]
      then
      recovery_mode
      else
	echo "Debe de elegir una opcion!"
    fi
  ;;
  "2.")
    long_entradas=`grep "menuentry '" /boot/grub/grub.cfg -c`
    contador=1
    opciones_entradas=`sed '150,190d' /boot/grub/grub.cfg | grep "menuentry '" | cut -d "(" -f 1 | tr -d ' '`
    for i in $opciones_entradas
    do
      i=`echo $i | cut -d "'" -f2`
      res_entrada=$res_entrada$contador". "$i" "
      let contador=$contador+1
    done
    ventana_entrada_predeterminada=`zenity --list --column="Codigo" --column="Sistema operativo" --title="Eliga una opcion" --height="300" --width="480" \
    $res_entrada`
    case $? in
      0)
      if [ 'x'$ventana_entrada_predeterminada != 'x' ]
      then
	ventana_entrada_predeterminada=`echo $ventana_entrada_predeterminada | cut -d "|" -f 1 | cut -d '.' -f 1`
	ventana_entrada_predeterminada=$((ventana_entrada_predeterminada-1))
	entrada_por_defecto "$ventana_entrada_predeterminada"
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
    ventana_timeout=`zenity --scale --text="Seleccione el tiempo de espera." --value="30" --max-value="60" --min-value="5" --step="5"`
    case $? in
      0)
	timeout $ventana_timeout
      ;;
      -1)
      ##Volver a la ventana ventana configuracion
      ;;
    esac

  ;;
  *)
  ;;
esac