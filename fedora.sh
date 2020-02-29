#!/bin/bash
: '
* @author Marco A Gallegos
* @date 2020-01-01
* @descripcion proveer opciones comunes para aligerar/automatizar la post instalacion o migracion de sistema operativo en este caso fedora
pendientes :
dbeaver
laravel/installer
laravel/lumen-installer

@vue/cli
deno

sublime extensions
All Autocomplete
oh my zsh theme power10k
'


#primer paso validar que sea fedora en version 30 o superior
distro_text=$(grep "^NAME" /etc/os-release)
version_text=$(grep "^VERSION_ID" /etc/os-release)
IFS='=' # space is set as delimiter
read -ra distro_arr <<< "$distro_text" # distro_text is read into an array as tokens separated by IFS
read -ra version_arr <<< "$version_text"

# instalar grupo Development Tools
# instalar qt5-devel cmake 

distro_name=${distro_arr[1]}
distro_version=${version_arr[1]}
fedora_version_rpm=$(rpm -E %fedora)
desktop_envirenment=$DESKTOP_SESSION # variable de entorno

if [[ $distro_name != "Fedora" && $distro_name != "fedora" ]] || [[ $distro_version < 30 ]]; then
  echo "no es una distro fedora soportada"
  exit
else
  echo "distro soportada"
fi

user=$(whoami)

declare -A config # especificamos que config es un array
config=(
  [ohmyzshurl]='https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh'

  [vscoderepo]='[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc'
  [vscoderepogpg]='https://packages.microsoft.com/keys/microsoft.asc'
  [vscodefilename]='vscode.repo'
  
  [vscodiumrepo]='[codium]
name=Vs Codium
baseurl=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg'
  [vscodiumfilename]='vscodium.repo'

  [flutterurl]='https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.5-stable.tar.xz'

  [rpmsusiofreeurl]="https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$fedora_version_rpm.noarch.rpm"
  [rpmsusionnonurl]="https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$fedora_version_rpm.noarch.rpm"
  [repopath]='/etc/yum.repos.d/'
  [rpmqafile]='rpmqa.txt'
  [composerbinpath]="export PATH=\$PATH:/home/$user/.config/composer/vendor/bin"
)

sudo_pass=$(zenity --password --title="contraseña sudo")
if [[ ! $sudo_pass ]]; then
  aviso "necesito el pasword de sudo" true
  exit
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
val_zsh=$(zsh --version)
val_oh_my_zsh=$(echo $ZSH)
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
val_grubby=$(grubby --help)

# aplicaciones/librerias de python
# pendiente
val_pip=$(pip show pip-tools)
val_pip=$(pip show spyder) # necesitas instalar libqtxdg

# probando
val_docker=$(docker --version)
# pendiente

#sdks
# pendiente
val_flutter=$(flutter --version)

# tiendas de software
val_snap=$(snap --version)
val_flatpak=$(flatpak --version)


# auxiliar para mostrar tanto notificaciones push como logs
aviso() {
  echo "$1"
  if $2 ; then
    zenity --notification --window-icon="info" --text="$1"
  fi
}

# instalamos todo aquello necesario
if [[ ! $val_git ]]; then
  echo $sudo_pass | sudo -S dnf install git gitflow -y
  aviso "Git se ha instalado" true
fi

if [[ ! $val_zsh ]]; then
  echo $sudo_pass | sudo -S dnf install curl zsh zsh-syntax-highlighting -y
  sh -c "$(curl -fsSL ${config[ohmyzshurl]})"
  aviso "se ha instalado zsh" true
fi

if [[ ! $val_oh_my_zsh ]]; then
  echo $sudo_pass | sh -c "$(curl -fsSL ${config[ohmyzshurl]})"
  aviso "se ha instalado oh my zsh" true
fi

if [[ ! $val_pip || ! $val_python ]]; then
  echo $sudo_pass | sudo -S dnf python-pip -y
  aviso "Python y/o PIP esta instalado" true
fi

if [[ ! $val_snap ]]; then
  # https://snapcraft.io/docs/installing-snap-on-fedora
  echo $sudo_pass | sudo -S dnf install snapd -y
  echo $sudo_pass | sudo -S ln -s /var/lib/snapd/snap /snap
  echo $sudo_pass | sudo -S systemctl enable snapd --now
  echo $sudo_pass | sudo -S sed -i '$a export PATH=$PATH:/var/lib/snapd/snap/bin' /etc/profile
  aviso "Se instalo Snap" true
fi

if [[ ! $val_flatpak ]]; then
  # https://developer.fedoraproject.org/deployment/flatpak/flatpak-install.html
  echo $sudo_pass | sudo -S dnf install flatpak -y
  aviso "Flatpak se instalo" true
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
  echo $sudo_pass | sudo -S dnf install code -y
  aviso "VsCode se ha instalado" true
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
  echo $sudo_pass | sudo -S dnf -y install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
  aviso "PHP se ha instalado" true
fi

if [[ ! $val_codium ]]; then
  # https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo
  if [ -f "${config[repopath]}${config[vscodiumfilename]}" ];then
    echo $sudo_pass | sudo -S rm "${config[repopath]}${config[vscodiumfilename]}"
  fi
  # echo $sudo_pass | sudo -S rpm --import ${config[vscoderepogpg]}
  echo $sudo_pass | sudo -S touch "${config[vscodiumfilename]}"
  echo $sudo_pass | sudo -S echo "${config[vscodiumrepo]}" > ${config[vscodiumfilename]}
  echo $sudo_pass | sudo -S mv ${config[vscodiumfilename]} "${config[repopath]}${config[vscodiumfilename]}"
  echo $sudo_pass | sudo -S dnf install codium -y
  aviso "Vs Codium se ha instalado" true
fi

if [[ ! $val_composer ]]; then
  # https://rpmfusion.org/Configuration
  echo $sudo_pass | sudo -S dnf -y install composer
  existe_path=$(grep "${config[composerbinpath]}" /etc/profile)
  if [[ ! $existe_path ]]; then
    echo $sudo_pass | sudo -S sed -i "\$a ${config[composerbinpath]}" /etc/profile
  fi
  source /etc/profile
  aviso "Composer se ha instalado cierra y abre tu terminal para ver los cambios reflejados" true
fi

if [[ ! $val_node || ! $val_npm ]]; then
  echo $sudo_pass | sudo -S dnf -y install nodejs npm
  aviso "NodeJs/npm se ha instalado" true
fi

if [[ ! $val_grubby ]];then
  echo $sudo_pass | sudo -S dnf install -y grubby
  aviso "Grubby se ha instalado" true
fi

# se ejecuta correctamente pendiente testear
if [[ ! $val_docker && $val_grubby ]];then
  # https://linuxconfig.org/how-to-install-docker-on-fedora-31
  echo $sudo_pass | sudo -S grubby --update-kernel=ALL --args='systemd.unified_cgroup_hierarchy=0'
  echo $sudo_pass | sudo -S dnf config-manager --add-repo=https://download.docker.com/linux/fedora/docker-ce.repo
  echo $sudo_pass | sudo -S dnf install -y docker-ce
  echo $sudo_pass | sudo -S systemctl enable --now docker
  echo $sudo_pass | sudo -S groupadd docker
  echo $sudo_pass | sudo -S usermod -aG docker "$user"
  val_grubby=$(grubby --help)
  aviso "Docker se ha instalado para usarlo reinicia el equipo" true
fi

if [[ ! $val_flutter ]];then
  # https://flutter.dev/docs/get-started/install/linux
  # se debe instalar en /opt/flutter por convencion
  # echo $sudo_pass | sudo -S 
  aviso "Flutter se ha instalado para usarlo reinicia el equipo" true
fi

# eliminamos el archivo
if [ -f "${config[rpmqafile]}" ];then
  echo $sudo_pass | sudo -S rm "${config[rpmqafile]}"
fi

opcion="basura :v"

while [[ $opcion != "" ]]; do
  opcion=$(zenity --list\
    --title="Post install on $host_name | $desktop_envirenment | $user SELinux $val_enforce"\
    --radiolist\
    --width="800"\
    --height="590"\
    --column="" --column="Opcion" --column="Descripcion" --column="Info"\
    TRUE   "Actualizar"          "Actualizar el sistema (solo dnf)"                                            "-"\
    FALSE  "Actualizar++"        "Actualizacion agresiva \n (dnf con limpieza de cache, snap, flatpak, etc)"   "-"\
    FALSE  "Pip Reqirements"     "Sincronizar pip reqirements"   "-"\
    FALSE  "Migracion"           "Respaldo Pre formateo de PC"                                                 "-"\
    FALSE  "Limpiar"             "Limpar la cache de pacman"                                                   "-"\
    FALSE  "Software"            "Software basico "                                                            "-"\
    FALSE  "IDES"                "IDE's y editores que uso para programar"                                     "-"\
    FALSE  "Swappiness"          "Editar el uso de la swap"                                                    "$val_swappines"\
    FALSE  "Complementos ATOM"   "Complementos basicos para el editor atom"                                    "${val_atom[0]}"\
    FALSE  "Cargar SSH"          "Reutilizar tu clave ssh copiada en ~/.ssh"                                   "-"\
    FALSE  "Paquetes Huerfanos"  "Eliminar paquetes ya no requeredos del sistema"                              "-"\
    FALSE  "Configurar git"      "Configurar nombre,email y editor para git"                                   "-"\
    FALSE  "Bootsplash"          "Eliminar el bootsplash solo texto"                                           "-"\
    FALSE  "Utilidades DE"       "Utilidades Extra para tu Entorno de escritorio"                              "$desktop_envirenment"
  )

  case $opcion in
    "Actualizar" )
    echo $sudo_pass | sudo -S dnf upgrade -y --refresh
    echo $sudo_pass | sudo -S pip install --upgrade pip
    ;;
    
    "Actualizar++" )
    echo $sudo_pass | sudo -S dnf clean all && sudo -S dnf upgrade -y --refresh
    echo $suco_pass | sudo -S snap refresh 
    echo $sudo_pass | sudo -S flatpak update
    echo $sudo_pass | sudo -S npm update -g
    composer global update
    echo $sudo_pass | sudo -S pip install --upgrade pip
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
    echo $sudo_pass | sudo -S dnf clean all
      ;;

    "Software" )
    echo $sudo_pass | sudo -S dnf install -y stacer vlc
    bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"
      ;;

    "IDES" )
    aviso "No implementado" true
    exit
    echo $sudo_pass | sudo -S dnf install 
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

    "Utilidades DE")
    if [[ $desktop_envirenment -eq "xfce" ]]; then
      echo $sudo_pass | sudo -S xfce4-xkb-plugin xfce4-screensaver xfce4-panel-profiles xfce-theme-manager thunar-archive-plugin
    fi

    if [[ $desktop_envirenment -eq "gnome" ]]; then
      aviso "No uses Gnome" true
    fi

    ;;

thunar-archive-plugin-
    "Temas, Iconos")
      aviso "Aun no implementado" true
    ;;

    "Bootsplash" )
    exit
    ;;
  esac

done

echo "saliendo del script"
