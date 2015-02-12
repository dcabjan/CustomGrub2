#!/bin/bash

frase="hola"
nuevonumero=" 5  "
nuevonumero=`echo $nuevonumero | tr -d " "`

test=`grep $frase prueba | tr -d " " | cut -d "=" -f 2`
sed -i "s/$test/$nuevonumero/g" prueba
