#!/bin/bash
val_swappines=$(cat /proc/sys/vm/swappiness)
val_apm=$(atom --version)
if [[ ! $val_apm ]]; then
  val_apm="---- No tienes instalado atom -----"
fi
opcion="basura :v"

while [[ $opcion != "" ]]; do
  opcion=$(zenity --list\
   --title="Algunas opciones comunes para despues de instalar Manjaro XFCE"\
   --radiolist\
   --width="700"\
   --height="500"\
   --column="" --column="Opcion" --column="Descripcion" --column="Estado actual"\
   TRUE   "Actualizar"        "Actualizar el sistema"                     "-" \
   FALSE  "Limpiar"           "limpar la cache de pacman"                 "-" \
   FALSE  "Software"          "software basico "                          "-"\
   FALSE  "IDES"              "IDE's y editores que uso para programar"   "-"\
   FALSE  "Swappiness"        "editar el uso de la swap"                  "$val_swappines"\
   FALSE  "Complementos ATOM" "complementos basicos para el editor atom"  "$val_apm"\
   FALSE  "SUDO"              "eliminar el periodo de gracia de sudo"     "-"\

  )

  case $opcion in
    "Actualizar" )
    pamac-updater
      ;;
    "Limpiar" )
    sudo pacman -Scc
      ;;

    "Software" )
    sudo pacman -S bleachbit vlc-nightly
      ;;

    "IDES" )
    sudo pacman -S qt5-tools qtcreator gdb gcc-multilib geany geany-plugins atom texlive-core texmaker
      ;;
    "Swappiness" )
    echo vm.swappiness=40 >> /etc/sysctl.d/99-sysctl.conf
      ;;
      "Complementos ATOM" )
      apm install color-picker emmet linter linter-cppcheck file-icons atom-ternjs atom-bootstrap3 pigments highlight-selected open-recent
      ;;
    "SUDO" )
    #Defaults	timestamp_timeout=0
      ;;
  esac

done
