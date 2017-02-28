#!/bin/bash
val_swappines=$(cat /proc/sys/vm/swappiness)
val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )
val_apm=$(atom --version)
user=$(whoami)


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
   FALSE  "Paquetes Huerfanos"  "Eliminar paquetes ya no requeredos del sistema"      "-"\
   FALSE  "Configurar git"      "Configurar nombre y email para git"                  "-"

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
    sudo pacman -S bleachbit vlc-nightly
    sudo pacman -S unrar zip unzip unace sharutils arj
    yaourt -S jdownloader2
    sudo pacman -S qbittorrent
    sudo pacman -S openshot
      ;;

    "IDES" )
    sudo pacman -S gdb gcc
    sudo pacman -S qt5-tools qtcreator
    sudo pacman -S geany geany-plugins atom
    sudo pacman -S texlive-core texmaker
      ;;


    "Swappiness" )
    if [[ -e "/etc/sysctl.d/99-sysctl.conf" ]]; then
      echo existe
    else
      echo creando
      sudo touch /etc/sysctl.d/99-sysctl.conf
    fi
    val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )
    sudo cp /etc/sysctl.d/99-sysctl.conf /etc/sysctl.d/99-sysctl.conf.old

    echo dame el valor para asignar
    read val_asignar_swap

    if [[ ${val_swap[0]} == "" ]]; then
      su -c "echo vm.swappiness=$val_asignar_swap >> /etc/sysctl.d/99-sysctl.conf"
    else
      su -c "sed -i "s%${val_swap[0]}%vm.swappines=$val_asignar_swap%g" /etc/sysctl.d/99-sysctl.conf"
    fi
      ;;


    "Complementos ATOM" )
    if [[ $val_apm == "---- No tienes instalado atom -----" ]]; then
      echo instalare atom
      sudo pacman -S atom
    fi
    sudo -u $user apm install color-picker emmet linter linter-cppcheck file-icons atom-ternjs atom-bootstrap3 pigments highlight-selected open-recent autocomplete-python platformio-ide-terminal atom-dark-fusion-syntax
      ;;



    "SUDO" )
    #Defaults	timestamp_timeout=0
    gksu "echo Defaults	timestamp_timeout=0.2 >> /etc/sudoers"
      ;;



    "Cargar SSH" )
    chmod 700 ~/.ssh/id_rsa
    ssh-add ~/.ssh/id_rsa
      ;;



    "Paquetes Huerfanos" )
    gksu "pacman -Rnsc $(pacman -Qtdq)"
    ;;



    "Configurar git")
    echo "cual es tu nombre : "
    read nombre_git
    echo "cual es tu email  : "
    read email_git
    git config --global user.name $nombre_git
    git config --global user.email $email_git
    ;;
  esac

done
