#!/bin/bash
: '
* @Author Marco A Gallegos
* @Date   2020-01-01
* @Update 2021-01-14
* @Descripcion 
*   proveer opciones comunes para aligerar/automatizar la post instalacion o migracion de sistema operativo en este caso fedora
'
# funciones auxiliares globales
read_conf_var(){
    VAR=$(grep $1 config.ini | cut -d '=' -f2)
    echo $VAR;
}

# auxiliar para mostrar tanto notificaciones push como logs
aviso() {
  echo "$1"
  if $2 ; then
    zenity --notification --window-icon="info" --text="$1"
  fi
}

#primer paso validar que sea fedora en version 32 o superior
distro_text=$(grep "^NAME" /etc/os-release)
version_text=$(grep "^VERSION_ID" /etc/os-release)
IFS='=' # space is set as delimiter
read -ra distro_arr <<< "$distro_text" # distro_text is read into an array as tokens separated by IFS
read -ra version_arr <<< "$version_text"

distro_name=${distro_arr[1]}
distro_version=${version_arr[1]}
fedora_version_rpm=$(rpm -E %fedora)
desktop_envirenment=$DESKTOP_SESSION # variable de entorno

if [[ $distro_name != "Fedora" && $distro_name != "fedora" ]] || [[ $distro_version < 33 ]]; then
  echo "no es una distro fedora soportada"
  exit
else
  echo "distro soportada"
fi

user=$(whoami)

declare -A config # especificamos que config es un array
config=(
  [ohmyzshurl]='https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
  [ohmybashurl]='https://raw.github.com/ohmybash/oh-my-bash/master/tools/install.sh'

  [vscoderepo]='[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc'
  [vscoderepogpg]='https://packages.microsoft.com/keys/microsoft.asc'
  [vscodefilename]='vscode.repo'
  
  [vscodiumrepo]='[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg'
  [vscodiumrepogpg]='https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg'
  [vscodiumfilename]='vscodium.repo'

  [flutterurl]='https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.5-stable.tar.xz'

  [rpmsusiofreeurl]="https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$fedora_version_rpm.noarch.rpm"
  [rpmsusionnonurl]="https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$fedora_version_rpm.noarch.rpm"
  [repopath]='/etc/yum.repos.d/'
  [rpmqafile]='rpmqa.txt'
  [composerbinpath]="export PATH=\$PATH:/home/$user/.config/composer/vendor/bin"
)


if [[ $1 ]]; then
  read -sp 'write your password: ' sudo_pass
  echo '\\n'
  if [[ ! $sudo_pass ]]; then
    aviso "necesito el pasword de sudo" true
    exit
  fi
else
  sudo_pass=$(zenity --password --title="contraseña sudo")
  if [[ ! $sudo_pass ]]; then
    aviso "necesito el pasword de sudo" true
    exit
  fi
fi

# revisiones preliminares
val_zenity=$(zenity --version)
val_stow=$(stow --version)
#instalaciones necesarias
if [[ ! $val_stow ]]; then
  echo $sudo_pass | sudo -S dnf install stow -y
  aviso "se instalo stow" true
fi
if [[ ! $val_stow ]]; then
  echo $sudo_pass | sudo -S dnf install zenity -y
  aviso "se instalo zenity" true
fi


# solo ejecutamos rpm -qa 1 vez por que es lento lo mandamos a un archivo y luego solo hacemos grep a este
if [ -f "${config[rpmqafile]}" ];then
  echo $sudo_pass | sudo -S rm "${config[rpmqafile]}"
fi
rpm -qa > "${config[rpmqafile]}"

# el swapiness activo en el sistema
val_swappines=$(cat /proc/sys/vm/swappiness)
# este archivo almacena el valor swapiness editado por el usuario
val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )

host_name=$(uname -n)
val_grubboot=$(grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub)
val_graciasudo="basura :v"
val_enforce=$(getenforce)

# librerias que se deben instalar
val_pythondevel=$(grep "python3-devel" ${config[rpmqafile]})

# aplicaciones/etc que se deben instalar
val_oh_my_bash=$(ls ~/.oh-my-bash/)
val_python=$(python --version)
val_pip=$(pip -V)
val_git=$(git --version)
val_code=$(code --version)
val_rmpfusion_free=$(grep "rpmfusion-free-release" ${config[rpmqafile]})
val_rmpfusion_nonfree=$(grep "rpmfusion-nonfree-release" ${config[rpmqafile]})
val_php=$(php --version)
val_codium=$(codium --version)
val_composer=$(composer --version)
val_node=$(node --version)
val_npm=$(npm --version)
val_docker=$(docker --version)

# aplicaciones/librerias de python
val_pip_tools=$(pip show pip-tools)

#sdks
# pendiente
val_flutter=$(flutter --version)

# tiendas de software
val_snap=$(snap --version)
val_flatpak=$(flatpak --version)

# instalamos todo aquello necesario
if [[ ! $val_pythondevel ]]; then
  echo $sudo_pass | sudo -S dnf install python3-devel -y
  aviso "python3 devel is installed" true
fi

if [[ ! $val_git ]]; then
  echo $sudo_pass | sudo -S dnf install git -y
  echo $sudo_pass | sudo -S dnf install gitflow -y
  aviso "Git is installed" true
fi

if [[ ! $val_oh_my_bash ]]; then
  echo $sudo_pass | sh -c "$(curl -fsSL ${config[ohmybashurl]})"
  aviso "oh my bash is installed" true
fi

if [[ ! $val_pip || ! $val_python ]]; then
  echo $sudo_pass | sudo -S dnf install python-pip -y
  aviso "Python y/o PIP esta instalado" true
fi

if [[ ! $val_snap ]]; then
  # https://snapcraft.io/docs/installing-snap-on-fedora
  echo $sudo_pass | sudo -S dnf install snapd -y
  echo $sudo_pass | sudo -S ln -s /var/lib/snapd/snap /snap
  echo $sudo_pass | sudo -S systemctl enable snapd --now
  echo $sudo_pass | sudo -S sed -i '$a export PATH=$PATH:/var/lib/snapd/snap/bin' /etc/profile
  aviso "Snap is installed" true
fi

if [[ ! $val_flatpak ]]; then
  # https://developer.fedoraproject.org/deployment/flatpak/flatpak-install.html
  echo $sudo_pass | sudo -S dnf install flatpak -y
  aviso "Flatpak is installed" true
fi

if [[ ! $val_code ]]; then
  # https://computingforgeeks.com/install-visual-studio-code-on-fedora/
  if [ -f "${config[repopath]}${config[vscodefilename]}" ];then
    echo $sudo_pass | sudo -S rm "${config[repopath]}${config[vscodefilename]}"
  fi
  echo $sudo_pass | sudo -S rpm --import ${config[vscoderepogpg]}
  echo $sudo_pass | sudo -S touch "${config[vscodefilename]}"
  echo $sudo_pass | sudo -S echo "${config[vscoderepo]}" > ${config[vscodefilename]}
  echo $sudo_pass | sudo -S mv ${config[vscodefilename]} "${config[repopath]}${config[vscodefilename]}"
  echo $sudo_pass | sudo -S dnf update -y
  echo $sudo_pass | sudo -S dnf install code -y
  aviso "VsCode is installed" true
fi

if [[ ! $val_rmpfusion_free ]]; then
  # https://rpmfusion.org/Configuration
  echo $sudo_pass | sudo -S dnf install ${config[rpmsusiofreeurl]} -y
  echo $sudo_pass | sudo -S dnf check-update
  aviso "RPM Fusion Free se ha instalado" true
fi

if [[ ! $val_rmpfusion_nonfree ]]; then
  # https://rpmfusion.org/Configuration
  echo $sudo_pass | sudo -S dnf install ${config[rpmsusionnonurl]} -y
  echo $sudo_pass | sudo -S dnf check-update
  aviso "RPM Fusion Nonfree se ha instalado" true
fi

if [[ ! $val_php ]]; then
  # https://rpmfusion.org/Configuration
  echo $sudo_pass | sudo -S dnf -y install php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
  aviso "PHP is installed" true
fi

if [[ ! $val_codium ]]; then
  # https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo
  if [ -f "${config[repopath]}${config[vscodiumfilename]}" ];then
    echo $sudo_pass | sudo -S rm "${config[repopath]}${config[vscodiumfilename]}"
  fi
  echo $sudo_pass | sudo -S rpm --import ${config[vscodiumrepogpg]}
  echo $sudo_pass | sudo -S touch "${config[vscodiumfilename]}"
  echo $sudo_pass | sudo -S echo "${config[vscodiumrepo]}" > ${config[vscodiumfilename]}
  echo $sudo_pass | sudo -S mv ${config[vscodiumfilename]} "${config[repopath]}${config[vscodiumfilename]}"
  echo $sudo_pass | sudo -S dnf update -y
  echo $sudo_pass | sudo -S dnf install codium -y
  aviso "Vs Codium se ha instalado" true
fi

if [[ ! $val_composer ]]; then
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	echo $sudo_pass | sudo php composer-setup.php --install-dir=/bin --filename=composer
	php -r "unlink('composer-setup.php');"
	
	existe_path=$(grep "${config[composerbinpath]}" /etc/profile)
	if [[ ! $existe_path ]]; then
		echo $sudo_pass | sudo -S sed -i "\$a ${config[composerbinpath]}" /etc/profile
	fi
	source /etc/profile
  aviso "Composer is installed" true
fi

if [[ ! $val_node || ! $val_npm ]]; then
  echo $sudo_pass | sudo -S dnf -y install nodejs npm
  aviso "NodeJs/npm se ha instalado" true
fi

if [[ ! $val_docker ]];then
  echo $sudo_pass | sudo -S dnf -y install dnf-plugins-core
  echo $sudo_pass | sudo -S dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  echo $sudo_pass | sudo -S dnf update -y
  echo $sudo_pass | sudo -S dnf install docker-ce docker-ce-cli containerd.io docker-compose -y
  echo $sudo_pass | sudo -S systemctl enable --now docker
  echo $sudo_pass | sudo groupadd docker
  echo $sudo_pass | sudo usermod -aG docker $USER
  newgrp docker 
  aviso "Docker is installed" true
fi

# eliminamos el archivo
if [ -f "${config[rpmqafile]}" ];then
  echo $sudo_pass | sudo -S rm "${config[rpmqafile]}"
fi


#definimos las funciones a usar por gui o por cli
# funcion de actualizacion menor
Update(){
  echo $sudo_pass | sudo -S dnf upgrade -y --refresh
  echo $sudo_pass | sudo -S pip install --upgrade pip
}

# funcion actualizacion completa
Updatefull(){
  # Todo Revisar complementos
  echo $sudo_pass | sudo -S dnf clean all
  echo $sudo_pass | sudo -S dnf upgrade -y --refresh
  echo $suco_pass | sudo -S snap refresh 
  echo $sudo_pass | sudo -S flatpak update -y 
  echo $sudo_pass | sudo -S npm update -g
  composer self-update -n -vv
  composer global update
  echo $sudo_pass | sudo -S pip install --upgrade pip
  if [[ $val_oh_my_bash ]]; then
    upgrade_oh_my_bash
    cd
  fi
  if [[ $val_pip_tools && -f $HOME/requirements.in ]]; then
    pip-compile $HOME/requirements.in -v
    echo $sudo_pass | sudo -S pip install -r $HOME/requirements.txt --upgrade
  fi
}

#instalar software util no necesario
Software(){
  echo $sudo_pass | sudo -S dnf install -y stacer vlc
  bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"
}


#instalar software util no necesario
VscodeExtensions(){
  code --install-extension ms-python.python
  code --install-extension ritwickdey.liveserver
  code --install-extension visualstudioexptteam.vscodeintellicode
  code --install-extension ms-azuretools.vscode-docker
  code --install-extension octref.vetur
  code --install-extension pkief.material-icon-theme
  code --install-extension felixfbecker.php-intellisense
  code --install-extension redhat.vscode-yaml
  code --install-extension xabikos.javascriptsnippets
  code --install-extension formulahendry.auto-rename-tag
  code --install-extension golang.go
  code --install-extension christian-kohler.path-intellisense
  code --install-extension formulahendry.auto-close-tag
  code --install-extension zignd.html-css-class-completion
  code --install-extension naumovs.color-highlight
  code --install-extension dsznajder.es7-react-js-snippets
  code --install-extension yzhang.markdown-all-in-one
  code --install-extension coenraads.bracket-pair-colorizer-2
  code --install-extension oderwat.indent-rainbow
  code --install-extension mikestead.dotenv
  code --install-extension thekalinga.bootstrap4-vscode
  code --install-extension onecentlin.laravel-blade
  code --install-extension mhutchie.git-graph
  code --install-extension mechatroner.rainbow-csv
  code --install-extension gruntfuggly.todo-tree
  code --install-extension onecentlin.laravel5-snippets
  code --install-extension orta.vscode-jest
  code --install-extension pivotal.vscode-boot-dev-pack
  code --install-extension njpwerner.autodocstring
  code --install-extension cjhowe7.laravel-blade
  code --install-extension ms-dotnettools.csharp
  code --install-extension equinusocio.vsc-material-theme-icons
}


# ejecutar alguna de las claves
executeOption(){
  # dentro de la funcion no es el argumento de el cli si no de la funcion
  case $1 in
      "update" )
        Update
      ;;
      
      "updatefull" )
        Updatefull
      ;;

      "software" )
        Software
      ;;
      
      "codeextensions" )
        VscodeExtensions
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

      "Utilidades DE")
        exit 0
        if [[ $desktop_envirenment -eq "xfce" ]]; then
          echo $sudo_pass | sudo -S dnf install xfce4-xkb-plugin xfce4-screensaver xfce4-panel-profiles xfce-theme-manager thunar-archive-plugin
        fi

        if [[ $desktop_envirenment -eq "gnome" ]]; then
          aviso "No uses Gnome" true
        fi
      ;;

      * )
        echo -n "unknown action : $1"
      ;;
    esac
}

# si tenemos argumentos desde cli tomamos el primero y realizamos la accion
if [[ $1 ]]; then
  executeOption $1
else
  opcion="basura :v"
  while [[ $opcion != "" ]]; do
    opcion=$(zenity --list\
      --title="Post install on $host_name | $desktop_envirenment | $user SELinux $val_enforce"\
      --radiolist\
      --width="800"\
      --height="590"\
      --column="" --column="Opcion" --column="Descripcion" --column="Info"\
      TRUE   "update"              "Actualizar el sistema (solo dnf)"                                            "-"\
      FALSE  "updatefull"          "Actualizacion agresiva \n (dnf con limpieza de cache, snap, flatpak, etc)"   "-"\
      FALSE  "software"            "Software basico "                                                            "-"\
      FALSE  "Swappiness"          "Editar el uso de la swap"                                                    "$val_swappines"\
      FALSE  "Complementos ATOM"   "Complementos basicos para el editor atom"                                    "${val_atom[0]}"\
      FALSE  "Cargar SSH"          "Reutilizar tu clave ssh copiada en ~/.ssh"                                   "-"\
      FALSE  "Paquetes Huerfanos"  "Eliminar paquetes ya no requeredos del sistema"                              "-"\
      FALSE  "Utilidades DE"       "Utilidades Extra para tu Entorno de escritorio"                              "$desktop_envirenment"
      FALSE  "Microzoa"            "Instalar tema Microzoa"                                                      ""
    )

    executeOption $opcion
  done
fi

echo "saliendo del script"
