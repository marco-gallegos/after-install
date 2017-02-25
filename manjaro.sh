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
   TRUE   "Actualizar"          "Actualizar el sistema"                               "-" \
   FALSE  "Limpiar"             "Limpar la cache de pacman"                           "-" \
   FALSE  "Software"            "Software basico "                                    "-"\
   FALSE  "IDES"                "IDE's y editores que uso para programar"             "-"\
   FALSE  "Swappiness"          "Editar el uso de la swap"                            "$val_swappines"\
   FALSE  "Complementos ATOM"   "Complementos basicos para el editor atom"            "$val_apm"\
   FALSE  "SUDO"                "Eliminar el periodo de gracia de sudo"               "-"\
   FALSE  "Cargar SSH"          "Reutilizar tu clave ssh copiada en ~/.ssh"           "-"\
   FALSE  "Paquetes Huerfanos"  "Eliminar paquetes ya no requeredos del sistema"      "-"

  )

  case $opcion in
    "Actualizar" )
    pamac-updater
      ;;
    "Limpiar" )
    sudo pacman -Scc
    yaourt -Scc
      ;;

    "Software" )
    gksu "pacman -S bleachbit vlc-nightly"
      ;;

    "IDES" )
    gksu "pacman -S qt5-tools qtcreator gdb gcc-multilib geany geany-plugins atom texlive-core texmaker"
      ;;
    "Swappiness" )
    su -c "echo vm.swappiness=40 >> /etc/sysctl.d/99-sysctl.conf"
      ;;
    "Complementos ATOM" )
    gksu "apm install color-picker emmet linter linter-cppcheck file-icons atom-ternjs atom-bootstrap3 pigments highlight-selected open-recent autocomplete-python platformio-ide-terminal atom-dark-fusion-syntax"
      ;;
    "SUDO" )
    #Defaults	timestamp_timeout=0
    gksu "echo Defaults	timestamp_timeout=0.2 >> /etc/sudoers"
      ;;
    "Cargar SSH" )
    ssh-add ~/.ssh/id_rsa
      ;;
    "Paquetes Huerfanos" )
    gksu "pacman -Rnsc $(pacman -Qtdq)"
    ;;
  esac

done
