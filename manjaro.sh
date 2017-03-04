#!/bin/bash
#evitar reescribir los archivos.old
val_swappines=$(cat /proc/sys/vm/swappiness)
val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )
val_apm=$(atom --version)
val_grubboot=$(grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub)
val_graciasudo="basura :v"
user=$(whoami)


if [[ ! $val_apm ]]; then
  val_apm="---- No tienes instalado atom -----"
fi

opcion="basura :v"

sudo_pass=$(zenity --password --title="contraseña sudo")

#root_pass=$(zenity --password --title="contraseña root")


while [[ $opcion != "" ]]; do
  opcion=$(zenity --list\
   --title="Algunas opciones comunes para despues de instalar Manjaro"\
   --radiolist\
   --width="600"\
   --height="400"\
   --column="" --column="Opcion" --column="Descripcion" --column="Estado actual"\
   TRUE   "Actualizar"          "Actualizar el sistema"                               "-" \
   FALSE  "Limpiar"             "Limpar la cache de pacman"                           "-" \
   FALSE  "Software"            "Software basico "                                    "-"\
   FALSE  "IDES"                "IDE's y editores que uso para programar"             "-"\
   FALSE  "Swappiness"          "Editar el uso de la swap"                            "$val_swappines"\
   FALSE  "Complementos ATOM"   "Complementos basicos para el editor atom"            "${val_apm[0]}"\
   FALSE  "SUDO"                "Eliminar el periodo de gracia de sudo"               "-"\
   FALSE  "Cargar SSH"          "Reutilizar tu clave ssh copiada en ~/.ssh"           "-"\
   FALSE  "Paquetes Huerfanos"  "Eliminar paquetes ya no requeredos del sistema"      "-"\
   FALSE  "Configurar git"      "Configurar nombre,email y editor para git"           "-"\
   FALSE  "Bootsplash"          "Eliminar el bootsplash solo texto"                   "-"
  )

  case $opcion in
    "Actualizar" )
    pamac-updater
      ;;
    "Limpiar" )
    echo $sudo_pass | sudo -S pacman -Scc
    echo $sudo_pass | sudo -S yaourt -Scc
      ;;

    "Software" )
    echo $sudo_pass | sudo -S  pacman -S bleachbit vlc-nightly telegram-qt cheese
    yaourt -S telegram-desktop-bin
    echo $sudo_pass | sudo -S pacman -S unrar zip unzip unace sharutils arj
    yaourt -S jdownloader2
    echo $sudo_pass | sudo -S pacman -S qbittorrent k3b youtube-dl ffmpeg obs-studio kodi
    echo $sudo_pass | sudo -S pacman -S openshot
      ;;

    "IDES" )
    echo $sudo_pass | sudo -S pacman -S gdb gcc python-pip gitg
    echo $sudo_pass | sudo -S pip install pygame
    echo $sudo_pass | sudo -S pacman -S qt5-tools qtcreator
    echo $sudo_pass | sudo -S pacman -S geany geany-plugins atom eric
    echo $sudo_pass | sudo -S pacman -S intellij-idea-community-edition
    echo $sudo_pass | sudo -S pacman -S texlive-core texmaker
      ;;


    "Swappiness" )
    if [[ -e "/etc/sysctl.d/99-sysctl.conf" ]]; then
      echo existe
    else
      echo creando
      echo $sudo_pass | sudo -S touch /etc/sysctl.d/99-sysctl.conf
    fi
    val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )
    echo $sudo_pass | sudo -S cp /etc/sysctl.d/99-sysctl.conf /etc/sysctl.d/99-sysctl.conf.old

    echo dame el valor para asignar
    read val_asignar_swap

    if [[ ${val_swap[0]} == "" ]]; then
      echo $sudo_pass | sudo -s "echo vm.swappiness=$val_asignar_swap >> /etc/sysctl.d/99-sysctl.conf"
    else
      echo $sudo_pass | sudo -S sed -i "s%${val_swap[0]}%vm.swappiness=$val_asignar_swap%g" /etc/sysctl.d/99-sysctl.conf
    fi
      ;;


    "Complementos ATOM" )
    if [[ $val_apm == "---- No tienes instalado atom -----" ]]; then
      echo instalare atom
      echo $sudo_pass | sudo -S pacman -S atom
    fi
    echo $sudo_pass | sudo -S -u $user apm install color-picker emmet linter linter-cppcheck file-icons atom-ternjs atom-bootstrap3 pigments highlight-selected open-recent autocomplete-python platformio-ide-terminal atom-dark-fusion-syntax
      ;;



    "SUDO" )
    #Defaults	timestamp_timeout=0
    if [[ -e "/etc/sudoers.old" ]]; then
      echo ya tienes un archivo old de respaldo
    else
      echo creando respaldo .old
      echo $sudo_pass | sudo -S "cp /etc/sudoers /etc/sudoers.old"
    fi
    val_graciasudo=$(echo $sudo_pass | sudo -S grep "Defaults timestamp_timeout"  /etc/sudoers)
    if [[ ${val_graciasudo[0]} == "" ]]; then
      echo $sudo_pass | sudo -S echo "Defaults	timestamp_timeout=0.4" >> /etc/sudoers
    else
      echo $sudo_pass | sudo -S sed -i "s%${val_graciasudo[0]}%Defaults timestamp_timeout=0.4%g" /etc/sudoers
    fi
      ;;



    "Cargar SSH" )
    if [[ -e "~/.ssh/id_rsa" ]]; then
      echo cambiando permiso a tu llave
      chmod 700 ~/.ssh/id_rsa
      ssh-add ~/.ssh/id_rsa
    else
      echo no tienes una llave ssh debes generarla o copiar la que tenias en tu home
    fi
      ;;



    "Paquetes Huerfanos" )
    echo $sudo_pass | sudo -S pacman -Rnsc $(pacman -Qtdq)
    ;;



    "Configurar git")
    echo "cual es tu nombre : "
    read nombre_git
    echo "cual es tu email  : "
    read email_git
    echo "editor para los commits : "
    read editor_git""
    git config --global user.name "$nombre_git"
    git config --global user.email "$email_git"
    git config --global core.editor "$editor_git"
    ;;

    "Bootsplash" )
    if [[ -e "/etc/default/grub.old" ]]; then
      echo ya tienes un archivo old de respaldo
    else
      echo creando respaldo .old
      echo $sudo_pass | sudo -S cp /etc/default/grub /etc/default/grub.old
    fi
    echo $sudo_pass | sudo -S sed -i "s%${val_grubboot[0]}%GRUB_CMDLINE_LINUX_DEFAULT=\"\"%g" /etc/default/grub
    echo $sudo_pass | sudo -S update-grub
    ;;
  esac

done
