#!/bin/bash
: '
* @author Marco A Gallegos
* @date 2020-01-01
* @descripcion proveer opciones comunes para aligerar la instalacion o migracion de sistema operativo en este caso fedora
'

# bug evitar reescribir los archivos.old
val_swappines=$(cat /proc/sys/vm/swappiness)
val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )
host_name=$(uname -n)
val_grubboot=$(grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub)
val_graciasudo="basura :v"
val_atom=$(atom --version)
val_python=$(python --version)
val_zsh=$(zsh --version)
user=$(whoami)
val_pip=$(pip -V)
val_zenity=$(zenity --version)


# auxiliar para mostrar tanto notificaciones push como logs
function aviso {
  echo "$1"
  zenity --notification --window-icon="info" --text="$1"
}

opcion="basura :v"
# sudo_pass=$(zenity --password --title="contraseña sudo")
# root_pass=$(zenity --password --title="contraseña root")

if [[ ! $val_pip ]]; then
  aviso "Python PIP\nInstalando Pyton PIP"
  echo $sudo_pass | sudo -S pacman -S --noconfirm python-pip
  aviso "Python PIP\nAhora esta instalado en tu sistema"
fi

if [[ ! $val_zenity ]]; then
  aviso "instalando zenity"
  echo $sudo_pass | sudo -S dnf install zenity -y
fi

val_pip=$(pip -V)

while [[ $opcion != "" && $val_zenity ]]; do
  opcion=$(zenity --list\
   --title="Post install on $host_name | $user"\
   --radiolist\
   --width="800"\
   --height="500"\
   --column="" --column="Opcion" --column="Descripcion" --column="Info"\
   TRUE   "Actualizar"          "Actualizar el sistema (solo dnf)"                                            "-"\
   FALSE  "Actualizar++"        "Actualizacion agresiva \n (dnf con limpieza de cache, snap, flatpak, etc)"   "-"\
   FALSE  "Migracion"           "Respaldo Pre formateo de PC"                                                 "$host_name"\
   FALSE  "Limpiar"             "Limpar la cache de pacman"                                                   "-"\
   FALSE  "Software"            "Software basico "                                                            "-"\
   FALSE  "IDES"                "IDE's y editores que uso para programar"                                     "-"\
   FALSE  "Swappiness"          "Editar el uso de la swap"                                                    "$val_swappines"\
   FALSE  "Complementos ATOM"   "Complementos basicos para el editor atom"                                    "${val_atom[0]}"\
   FALSE  "Cargar SSH"          "Reutilizar tu clave ssh copiada en ~/.ssh"                                   "-"\
   FALSE  "Paquetes Huerfanos"  "Eliminar paquetes ya no requeredos del sistema"                              "-"\
   FALSE  "Configurar git"      "Configurar nombre,email y editor para git"                                   "-"\
   FALSE  "Bootsplash"          "Eliminar el bootsplash solo texto"                                           "-"
  )

  case $opcion in
    "Actualizar" )
    echo $sudo_pass | sudo -S dnf upgrade -y --refresh
    echo $sudo_pass | sudo -S pip install --upgrade pip
      ;;
    
    "Actualizar++" )
    echo $sudo_pass | sudo -S dnf clean all && sudo -S dnf upgrade -y --refresh && sudo -S snap refresh 
    echo $sudo_pass | sudo flatpak update && sudo -S npm update -g && composer global update
    sudo -S pip install --upgrade pip
    sh $ZSH/tools/upgrade.sh
      ;;

    "Migracion" )
    exit
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
    sudo -S dnf clean all
      ;;

    "Software" )
    exit
    echo $sudo_pass | sudo -S pacman -S --noconfirm curl zsh zsh-autosuggestions zsh-completions zsh-history-substring-search  zsh-syntax-highlighting fakeroot manjaro-tools-pkg manjaro-tools-base autoconf gcc jdk9-openjdk jre9-openjdk
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo $sudo_pass | sudo -S pacman -S --noconfirm mariadb mariadb-clients php phpmyadmin
    echo $sudo_pass | sudo -S pacman -S --noconfirm bleachbit vlc-nightly cheese python-pip anki compton dia speedcrunch
    echo $sudo_pass | sudo -S pacman -S --noconfirm unrar zip unzip unace sharutils arj p7zip freemind gparted grsync ttf-inconsolata
    echo $sudo_pass | sudo -S pacman -S --noconfirm qbittorrent k3b youtube-dl ffmpeg kodi audacity quodlibet handbrake
    echo $sudo_pass | sudo -S pacman -S --noconfirm openshot obs-studio htop lshw mysql-workbench plank thunderbird
    echo $sudo_pass | sudo -S pacman -S --noconfirm gimp remmina freeglut gedit gedit-plugins
    echo $sudo_pass | sudo -S pip install subnetting mysqlclient pygame yaourt
    yaourt -S telegram-desktop-bin
    yaourt -S jdownloader2
    yaourt -S google-chrome
    yaourt -S dbeaver-ce
    yaourt -S matcha-gtk-theme
    #spotify
    gpg --keyserver hkps://pgp.mit.edu --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
    yaourt -S spotify-stable multisystem sublime-text-dev
      ;;

    "IDES" )
    exit
    echo $sudo_pass | sudo -S pacman -S --noconfirm gdb gcc python-pip gitg git jdk9-openjdk jre9-openjdk
    echo $sudo_pass | sudo -S pacman -S --noconfirm qt5-tools qtcreator
    echo $sudo_pass | sudo -S pacman -S --noconfirm geany geany-plugins atom eric pycharm-community-edition codeblocks
    echo $sudo_pass | sudo -S pacman -S --noconfirm intellij-idea-community-edition
    echo $sudo_pass | sudo -S pacman -S --noconfirm texlive-core texmaker
      ;;


    "Swappiness" )
    exit
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
    exit
    if [[ $val_apm == "---- No tienes instalado atom -----" ]]; then
      echo instalare atom
      echo $sudo_pass | sudo -S pacman -S --noconfirm atom
    fi
    echo $sudo_pass | sudo -S -u $user apm install color-picker emmet linter linter-cppcheck file-icons atom-ternjs atom-bootstrap3 pigments highlight-selected open-recent autocomplete-python platformio-ide-terminal atom-dark-fusion-syntax atom-material-ui seti-syntax linter-ui-default ide-php atom-ide-ui
      ;;


    "Cargar SSH" )
    exit
    if [[ -e "~/.ssh/id_rsa" ]]; then
      echo cambiando permiso a tu llave
      chmod 700 ~/.ssh/id_rsa
      ssh-add ~/.ssh/id_rsa
    else
      echo no tienes una llave ssh debes generarla o copiar la que tenias en tu home
    fi
      ;;



    "Paquetes Huerfanos" )
    exit
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
    exit
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

echo "saliendo del script"