#!/bin/bash
: '
* @author Marco A Gallegos
* @date 2017-01-01
* @descripcion proveer opciones comunes para aligerar/automatizar la post instalacion o migracion de sistema operativo en este caso fedora
pendientes :
!Cambiar yaourt por yay puesto que yaourt fue descontinuado
stacer
deno

sublime extensions
All Autocomplete
'
#primer paso validar que sea fedora en version 30 o superior
distro_text=$(grep "^NAME" /etc/os-release)
IFS='=' # space is set as delimiter
read -ra distro_arr <<< "$distro_text" # distro_text is read into an array as tokens separated by IFS

distro_name=${distro_arr[1]}
desktop_envirenment=$DESKTOP_SESSION

if [[ $distro_name != '"Manjaro Linux"' ]]; then
  echo "no es una distro Manjaro"
  exit
else
  echo "distro soportada"
fi

user=$(whoami)

declare -A config # especificamos que config es un array
config=(
  [msginstall]='Ahora esta instalado en tu sistema'

  [ohmyzshurl]='https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh'

  [flutterurl]='https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.5-stable.tar.xz'

  [composerbinpath]="export PATH=\$PATH:/home/$user/.config/composer/vendor/bin"
)

sudo_pass=$(zenity --password --title="contraseña sudo")
if [[ ! $sudo_pass ]]; then
  exit
fi

#evitar reescribir los archivos.old
val_yay=$(yay --version)

# el swapiness activo en el sistema
val_swappines=$(cat /proc/sys/vm/swappiness)
# este archivo almacena el valor swapiness editado por el usuario
val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )

host_name=$(uname -n)
val_grubboot=$(grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub)
val_graciasudo="basura :v"

# librerias que se deben instalar
# val_pythondevel=$(grep "python3-devel" ${config[rpmqafile]})

# aplicaciones/etc que se deben instalar
val_atom=$(atom --version)
val_zsh=$(zsh --version)
val_oh_my_zsh=$(echo $ZSH)
val_python=$(python --version)
val_pip=$(pip -V)
val_git=$(git --version)
val_git_flow=$(git flow version)
val_code=$(code --version)
val_php=$(php --version)
val_codium=$(codium --version)
val_composer=$(composer --version)
val_node=$(node --version)
val_npm=$(npm --version)
val_java=$(pacman -Q jre8-openjdk)
val_dbeaver="ok"

# npm global
val_vue_cli=$(vue --version)

# php global
val_laravel=$(laravel --version)
val_lumen=$(lumen --version)

# aplicaciones/librerias de python
# pendiente
val_pip_tools=$(pip show pip-tools)
val_spyder=$(pip show spyder) # necesitas instalar libqtxdg

# probando
val_docker=$(docker --version)

#sdks
val_flutter=$(flutter --version)
val_android_studio=$( pacman -Q android-studio)


# auxiliar para mostrar tanto notificaciones push como logs
aviso() {
  echo "$1"
  if $2 ; then
    zenity --notification --window-icon="info" --text="$1"
  fi
}

opcion="basura :v"

# instalamos todo aquello necesario
if [[ ! $val_yay ]]; then
  echo $sudo_pass | sudo -S pacman -Sy --noconfirm yay
  aviso "Yay ${config[msginstall]}" true
fi

if [[ ! $val_git ]]; then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm git
  aviso "Git ${config[msginstall]}" true
fi

if [[ ! $val_git_flow ]]; then
  yay -Sy --noconfirm gitflow-avh
  aviso "Git Flow ${config[msginstall]}" true
fi

if [[ ! $val_zsh ]]; then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm curl zsh zsh-syntax-highlighting
  aviso "Zsh ${config[msginstall]}" true
fi

if [[ ! $val_oh_my_zsh ]]; then
  sh -c "$(curl -fsSL ${config[ohmyzshurl]})"
  aviso "Oh My Zsh ${config[msginstall]}" true
fi

if [[ ! $val_code ]]; then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm code
  aviso "Visual Studio Code ${config[msginstall]}" true
fi

if [[ ! $val_atom ]]; then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm atom
  aviso "Atom ${config[msginstall]}" true
fi

if [[ ! $val_pip || ! $val_python ]]; then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm python-pip
  aviso "Python ${config[msginstall]}" true
fi

if [[ ! $val_php ]]; then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm php php-gd
  aviso "PHP se ha instalado" true
fi

if [[ ! $val_codium ]]; then
  echo $sudo_pass | sudo -S snap install codium --classic
  aviso "Vs Codium ${config[msginstall]}" true
fi

if [[ ! $val_composer ]]; then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm composer
  existe_path=$(grep "${config[composerbinpath]}" /etc/profile)
  if [[ ! $existe_path ]]; then
    echo $sudo_pass | sudo -S sed -i "\$a ${config[composerbinpath]}" /etc/profile
  fi
  source /etc/profile
  aviso "Composer se ha instalado \n cierra y abre tu terminal para ver los cambios reflejados" true
fi

if [[ ! $val_node || ! $val_npm ]]; then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm nodejs npm
  aviso "NodeJs/npm ${config[msginstall]}" true
fi

if [[ ! $val_docker ]];then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm docker
  echo $sudo_pass | sudo -S systemctl enable --now docker
  echo $sudo_pass | sudo -S groupadd docker
  echo $sudo_pass | sudo -S usermod -aG docker "$user"
  aviso "Docker se ha instalado para usarlo reinicia el equipo" true
fi

if [[ ! $val_flutter ]];then
  yay -Sy --noconfirm flutter
  aviso "Flutter ${config[msginstall]}" true
fi

# dependencias de pip
if [[ ! $val_pip_tools ]];then
  echo $sudo_pass | sudo -S pip install pip-tools
  aviso "Pip Tools ${config[msginstall]}" true
fi

if [[ ! $val_spyder ]];then
  echo $sudo_pass | sudo -S pip install spyder
  aviso "Spyder ${config[msginstall]}" true
fi

if [[ ! $val_java ]];then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm jre8-openjdk
  aviso "Java ${config[msginstall]}" true
fi

if [[ ! $val_android_studio ]];then
  echo $sudo_pass | yay -Sy --noconfirm android-studio
  aviso "Android Studio ${config[msginstall]}" true
fi

if [[ ! $val_vue_cli ]];then
  echo $sudo_pass | sudo -S npm install -g @vue/cli
  aviso "Vue Cli ${config[msginstall]}" true
fi

if [[ ! $val_laravel ]];then
  composer global require laravel/installer
  aviso "Laravel Installer ${config[msginstall]}" true
fi

if [[ ! $val_lumen ]];then
  composer global require laravel/lumen-installer
  aviso "Lumen Installer ${config[msginstall]}" true
fi

if [[ ! $val_dbeaver ]];then
  echo $sudo_pass | sudo -S yay -Sy --noconfirm dbeaver
  aviso "Dbeaver ${config[msginstall]}" true
fi

while [[ $opcion != "" ]]; do
  opcion=$(zenity --list\
    --title="Algunas opciones comunes para despues de instalar Manjaro"\
    --radiolist\
    --width="700"\
    --height="600"\
    --column="" --column="Opcion" --column="Descripcion" --column="Estado actual"\
    TRUE   "Actualizar"          "Actualizar el sistema"                               "-"\
    FALSE  "Migracion"           "Respaldo Pre formateo de PC"                         "$host_name"\
    FALSE  "Limpiar"             "Limpar la cache de pacman"                           "-"\
    FALSE  "Software"            "Software basico "                                    "-"\
    FALSE  "IDES"                "IDE's y editores que uso para programar"             "-"\
    FALSE  "Swappiness"          "Editar el uso de la swap"                            "$val_swappines"\
    FALSE  "Complementos ATOM"   "Complementos basicos para el editor atom"            "-"\
    FALSE  "SUDO"                "Eliminar el periodo de gracia de sudo"               "-"\
    FALSE  "Cargar SSH"          "Reutilizar tu clave ssh copiada en ~/.ssh"           "-"\
    FALSE  "Paquetes Huerfanos"  "Eliminar paquetes ya no requeredos del sistema"      "-"\
    FALSE  "Configurar git"      "Configurar nombre,email y editor para git"           "-"\
    FALSE  "Bootsplash"          "Eliminar el bootsplash solo texto"                   "-"\
    FALSE  "Barra Pacman"        "cambiar barra de progreso de pacman por un pacman"   "-"\
    FALSE  "Microzoa"            "Instalar Tema de cursor Microzoa"                    ""
  )

  case $opcion in
    "Actualizar" )
    yay -Syua --noconfirm
    echo $sudo_pass | sudo -S pip install --upgrade pip
    echo $suco_pass | sudo -S snap refresh
    echo $sudo_pass | sudo -S npm update -g
    composer global update
      ;;

    "Migracion" )
    # hace falta un analisis funcional
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
    echo $sudo_pass | sudo -S yay -Scc --noconfirm
      ;;
    
    "Software" )
    exit
    echo $sudo_pass | sudo -S yay -Sy --noconfirm fakeroot manjaro-tools-pkg manjaro-tools-base autoconf gcc
    echo $sudo_pass | sudo -S yay -Sy --noconfirm mariadb mariadb-clients
    echo $sudo_pass | sudo -S yay -Sy --noconfirm bleachbit cheese anki compton dia speedcrunch
    echo $sudo_pass | sudo -S yay -Sy --noconfirm unrar zip unzip unace sharutils arj p7zip freemind gparted grsync
    echo $sudo_pass | sudo -S yay -Sy --noconfirm qbittorrent k3b ffmpeg kodi audacity quodlibet handbrake
    echo $sudo_pass | sudo -S yay -Sy --noconfirm openshot obs-studio htop lshw mysql-workbench plank thunderbird
    echo $sudo_pass | sudo -S yay -Sy --noconfirm gimp remmina freeglut
    echo $sudo_pass | sudo -S pip install subnetting
    bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"
    #yaourt -S telegram-desktop-bin
    #yaourt -S jdownloader2
    #yaourt -S google-chrome
    #yaourt -S dbeaver-ce
    #yaourt -S matcha-gtk-theme
    #spotify
    #gpg --keyserver hkps://pgp.mit.edu --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
    #yaourt -S spotify-stable multisystem sublime-text-dev
      ;;

    "IDES" )
    exit
    echo $sudo_pass | sudo -S yay -Sy --noconfirm gdb gcc python-pip gitg git
    echo $sudo_pass | sudo -S yay -Sy --noconfirm qt5-tools qtcreator
    echo $sudo_pass | sudo -S yay -Sy --noconfirm geany geany-plugins atom eric pycharm-community-edition codeblocks
    echo $sudo_pass | sudo -S yay -Sy --noconfirm intellij-idea-community-edition
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
    echo $sudo_pass | sudo -S -u $user apm install color-picker emmet linter linter-cppcheck file-icons atom-ternjs atom-bootstrap3 pigments highlight-selected open-recent autocomplete-python platformio-ide-terminal atom-dark-fusion-syntax atom-material-ui seti-syntax linter-ui-default ide-php atom-ide-ui
      ;;

    "SUDO" )
    exit
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
    
    "Microzoa")
    echo $sudo_pass | sudo -S 7z x resources/154458-microzoa.7z -o/usr/share/icons/ -y
    aviso "Microzoa ${config[msginstall]}" true
    ;;
  esac

done
