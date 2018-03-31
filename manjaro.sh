#!/bin/bash
#evitar reescribir los archivos.old
val_swappines=$(cat /proc/sys/vm/swappiness)
val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )
val_atom=$(atom --version)
host_name=$(uname -n)
val_grubboot=$(grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub)
val_graciasudo="basura :v"
user=$(whoami)

function aviso {
  zenity --notification --window-icon="info" --text="$1"
}

if [[ ! $val_atom ]]; then
  val_atom="Atom\nNo tienes instalado atom"
  aviso $val_atom
fi

opcion="basura :v"
sudo_pass=$(zenity --password --title="contraseña sudo")
#root_pass=$(zenity --password --title="contraseña root")

while [[ $opcion != "" ]]; do
  opcion=$(zenity --list\
   --title="Algunas opciones comunes para despues de instalar Manjaro"\
   --radiolist\
   --width="700"\
   --height="500"\
   --column="" --column="Opcion" --column="Descripcion" --column="Estado actual"\
   TRUE   "Actualizar"          "Actualizar el sistema"                               "-"\
   FALSE  "Migracion"           "Respaldo Pre formateo de PC"                         "$host_name"\
   FALSE  "Limpiar"             "Limpar la cache de pacman"                           "-"\
   FALSE  "Software"            "Software basico "                                    "-"\
   FALSE  "IDES"                "IDE's y editores que uso para programar"             "-"\
   FALSE  "Swappiness"          "Editar el uso de la swap"                            "$val_swappines"\
   FALSE  "Complementos ATOM"   "Complementos basicos para el editor atom"            "${val_atom[0]}"\
   FALSE  "SUDO"                "Eliminar el periodo de gracia de sudo"               "-"\
   FALSE  "Cargar SSH"          "Reutilizar tu clave ssh copiada en ~/.ssh"           "-"\
   FALSE  "Paquetes Huerfanos"  "Eliminar paquetes ya no requeredos del sistema"      "-"\
   FALSE  "Configurar git"      "Configurar nombre,email y editor para git"           "-"\
   FALSE  "Bootsplash"          "Eliminar el bootsplash solo texto"                   "-"\
   FALSE  "Barra Pacman"        "cambiar barra de progreso de pacman por un pacman"   "-"
  )

  case $opcion in
    "Actualizar" )
    yaourt -Syua
    echo $sudo_pass | sudo -S pip install --upgrade pip
      ;;

    "Migracion" )
    directorio_destino=$(zenity --file-selection --directory --title="Directorio de destino para el respaldo")
    directorio_destino+="/"
    directorio_destino+=$host_name
    mkdir $directorio_destino
    directorio_destino+="/"
    directorio_destino+=$user
    mkdir $directorio_destino
    cp -R $HOME/.ssh $directorio_destino
    echo $sudo_pass | sudo -S 7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on $directorio_destino/http.7z /srv/http
    for x in `ls $HOME`;
    do
    cp -R $HOME/$x $directorio_destino;
    done
    aviso "respaldo terminado"
      ;;

    "Limpiar" )
    sudo -S pacman -Scc
    sudo -S yaourt -Scc
      ;;
    "Software" )
    echo $sudo_pass | sudo -S pacman -S curl
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo $sudo_pass | sudo -S pacman -S mariadb mariadb-clients php phpmyadmin
    echo $sudo_pass | sudo -S pacman -S bleachbit vlc-nightly cheese python-pip anki compton dia speedcrunch
    echo $sudo_pass | sudo -S pacman -S unrar zip unzip unace sharutils arj p7zip freemind gparted grsync ttf-inconsolata
    echo $sudo_pass | sudo -S pacman -S qbittorrent k3b youtube-dl ffmpeg kodi audacity quodlibet handbrake
    echo $sudo_pass | sudo -S pacman -S openshot obs-studio htop lshw mysql-workbench plank thunderbird
    echo $sudo_pass | sudo -S pacman -S gimp remmina freeglut gedit gedit-plugins
    echo $sudo_pass | sudo -S pip install subnetting mysqlclient pygame yaourt
    yaourt -S telegram-desktop-bin
    yaourt -S jdownloader2
    yaourt -S google-chrome
    yaourt -S dbeaver-ce
    yaourt -S matcha-gtk-theme
    yaourt -S spotify multisystem sublime-text-dev
      ;;

    "IDES" )
    echo $sudo_pass | sudo -S pacman -S gdb gcc python-pip gitg git
    echo $sudo_pass | sudo -S pacman -S qt5-tools qtcreator
    echo $sudo_pass | sudo -S pacman -S geany geany-plugins atom eric pycharm-community-edition codeblocks
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
    echo $sudo_pass | sudo -S -u $user apm install color-picker emmet linter linter-cppcheck file-icons atom-ternjs atom-bootstrap3 pigments highlight-selected open-recent autocomplete-python platformio-ide-terminal atom-dark-fusion-syntax atom-material-ui seti-syntax linter-ui-default
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
      echo $sudo_pass | sudo -S echo "Defaults	timestamp_timeout=0.1" >> /etc/sudoers
    else
      echo $sudo_pass | sudo -S sed -i "s%${val_graciasudo[0]}%Defaults timestamp_timeout=0.1%g" /etc/sudoers
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
    git config color.ui true
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

    "Barra Pacman")
    if [[ -e "/etc/pacman.conf.bak" ]]; then
      aviso "ya tienes un respaldo"
    else
      aviso "realizando respaldo"
      echo sudo_pass | sudo -S cp /etc/pacman.conf /etc/pacman.conf.bak
    fi
    echo $sudo_pass | sudo -S sed -i "s%#Color%Color\nILoveCandy%g" /etc/pacman.conf
    aviso "Pacman\nAhora pacman esta en la terminal"
    ;;
  esac

done
