#!/bin/bash
val_swappines=$(cat /proc/sys/vm/swappiness)
val_apm=$(atom --version)
if [[ ! $val_apm ]]; then
  val_apm="---- No tienes instalado atom -----"
fi

opcion=$(zenity --list\
 --title="Algunas opciones comunes para despues de instalar Manjaro XFCE"\
 --radiolist\
 --width="700"\
 --height="500"\
 --column="" --column="Opcion" --column="Descripcion" --column="Estado actual"\
 FALSE  "Actualizar"        "Actualizar el sistema"                     "-" \
 FALSE  "Limpiar"           "limpar la cache de pacman"                 "-" \
 FALSE  "Software"          "software basico "                          "-"\
 FALSE  "IDES"              "IDE's y editores que uso para programar"   "-"\
 FALSE  "Swappiness"        "editar el uso de la swap"                  "$val_swappines"\
 FALSE  "Complementos ATOM" "complementos basicos para el editor atom"  "$val_apm"
)

echo $opcion
