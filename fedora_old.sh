#!/bin/bash
: '
* @author Marco A Gallegos
* @date 2020-01-01
* @descripcion proveer opciones comunes para aligerar la instalacion o migracion de sistema operativo en este caso fedora sin gui
* consideramso que provee un argumento o no
* siempre trabajamos sobre la distro mas nueva0bf6ab8dba3c1386169c47b8bcc204974fe274f:fedora_nox.sh
'
#primer paso validar que sea fedora en version 30 o superior
distro_text=$(grep "^NAME" /etc/os-release)
version_text=$(grep "^VERSION_ID" /etc/os-release)
IFS='=' # space is set as delimiter
read -ra distro_arr <<< "$distro_text" # distro_text is read into an array as tokens separated by IFS
read -ra version_arr <<< "$version_text" 


distro_name=${distro_arr[1]}
distro_version=${version_arr[1]}

if [[ $distro_name != "Fedora" && $distro_name != "fedora" ]] || [[ $distro_version < 31 ]]; then
  echo "no es una distro fedora soportada"
  exit
else
  echo "distro soportada"
  echo "sudo password : "
  read -s sudo_pass
  if [[ ! $sudo_pass ]]; then
    exit
  fi
fi


declare -A config # especificamos que config es un array, se puede recorrer 
config=(
  [ohmyzshurl]='https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
  [ok]='nadamas'

  [vscoderepo]='
  [code]
  name=Visual Studio Code
  baseurl=https://packages.microsoft.com/yumrepos/vscode
  enabled=1
  gpgcheck=1
  gpgkey=https://packages.microsoft.com/keys/microsoft.asc
  '
  [vscoderepogpg]='https://packages.microsoft.com/keys/microsoft.asc'
  [vscodefilename]='vscode.repo'
  
  [repopath]='/etc/yum.repos.d/'
)

declare -A opciones
# opciones para mostrar en el menu
opciones=(
  [Actualizar]="Actualizar el sistema (solo dnf)\n"
  [Actualizar++]="Actualizacion agresiva (dnf con limpieza de cache, snap, flatpak, etc)\n"
  [Migracion]="Respaldo Pre formateo de PC\n"
  [Limpar]="Limpar la cache de DNF\n"
  [Software]="Software basico\n"
  [IDES]="IDE's y editores que uso para programar\n"
  [Swappiness]="Editar el uso de la swap\n"
  [ComplementosAtom]="Complementos basicos para el editor atom\n"
  [CargarSSH]="Reutilizar tu clave ssh copiada en ~/.ssh\n"
  [PaquetesHuerfanos]="Eliminar paquetes ya no requeredos del sistema\n"
  [Configurargit]="Configurar nombre,email y editor para git\n"
  [Bootsplash]="Eliminar el bootsplash solo texto\n" 
)
# vicular los indices con un numero para eleccion sencilla en menu
declare -A opciones_indices
index=0
for valor in ${!opciones[@]}
do
  opciones_indices[$index]=$valor
  index=`expr $index + 1`
done

# el swapiness activo en el sistema
val_swappines=$(cat /proc/sys/vm/swappiness)
# este archivo almacena el valor swapiness editado por el usuario
val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )

host_name=$(uname -n)
val_grubboot=$(grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub)
val_graciasudo="basura :v"
user=$(whoami)
val_enforce=$(getenforce)

# aplicaciones que se deben instalar
val_zsh=$(zsh --version)
val_oh_my_zsh=$(echo $ZSH)
val_python=$(python --version)
val_pip=$(pip -V)
val_git=$(git --version)

# de aca para abajo pendiente de implementar
val_code=$(code --version)
val_codium=$(code --version)
val_node=$(node --version)
val_node=$(npm --version)
val_php=$(php --version)
val_composer=$(code --version)
val_docker=$(docker --version)

# tiendas de software
val_snap=$(snap --version)
val_flatpak=$(flatpak --version)


# funciones
# auxiliar para mostrar tanto notificaciones push como logs
aviso() {
  echo "$1"
}

<<<<<<< HEAD:fedora_old.sh
opcion="basura :v"
echo "sudo password : "
read -s sudo_pass
if [[ ! $sudo_pass ]]; then
  exit
fi


# instalamos todo aquello necesario
if [[ ! $val_git ]]; then
   aviso "Instalando git"
   echo $sudo_pass | sudo -S dnf install git gitflow -y
   aviso "Git se ha instalado" true
fi

if [[ ! $val_zsh ]]; then
  aviso "Instalando zsh"
  echo $sudo_pass | sudo -S dnf install curl git zsh zsh-syntax-highlighting -y
  echo $sudo_pass | sh -c "$(curl -fsSL ${config[ohmyzshurl]})"
  aviso "se ha instalado zsh"
fi

if [[ ! $val_oh_my_zsh ]]; then
  aviso "Instalando zsh"
  echo $sudo_pass | sh -c "$(curl -fsSL ${config[ohmyzshurl]})"
  aviso "se ha instalado oh my zsh" true
fi

if [[ ! $val_python ]]; then
  aviso "Instalando python"
  echo $sudo_pass | sudo -S dnf install python-pip -y
  aviso "Python ahora esta instalado" true
fi

if [[ ! $val_pip ]]; then
  aviso "Instalando Pyton PIP"
  echo $sudo_pass | sudo -S dnf python-pip -y
  aviso "Python PIP esta instalado" true
fi


# pendiente
if [[ ! $val_code ]]; then
  echo $sudo_pass | sudo -S rpm --import https://packages.microsoft.com/keys/microsoft.asc
  echo $sudo_pass | sudo -S touch /etc/yum.repos.d/vscode.repo
  echo $sudo_pass | sudo -S echo "[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > vscode.repo
  echo $sudo_pass | sudo -S mv vscode.repo /etc/yum.repos.d/vscode.repo
  echo $sudo_pass | sudo -S dnf install code -y
  aviso "VsCode se ha instalado" true
fi



val_pip=$(pip -V)

while [[ $opcion != "" ]]; do
    echo -e "Info \n"\
    "Actualizar el sistema (solo dnf)\n"                                          \
    "Actualizacion agresiva (dnf con limpieza de cache, snap, flatpak, etc)\n"    \
    "Respaldo Pre formateo de PC\n"                                               \
    "Limpar la cache de pacman\n"                                                 \
    "Software basico\n"                                                            \
    "IDE's y editores que uso para programar\n"                                     \
    "Editar el uso de la swap\n"                                                    \
    "Complementos basicos para el editor atom\n"                                    \
    "Reutilizar tu clave ssh copiada en ~/.ssh\n"                                   \
    "Eliminar paquetes ya no requeredos del sistema\n"                              \
    "Configurar nombre,email y editor para git\n"                                   \
    "Eliminar el bootsplash solo texto\n" 

  read opcion                                          

  case $opcion in
=======
# funcion que ejecuta las acciones
execute_option(){
  case $1 in
>>>>>>> 90bf6ab8dba3c1386169c47b8bcc204974fe274f:fedora_nox.sh
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


    "ComplementosAtom" )
    exit
    if [[ $val_apm == "---- No tienes instalado atom -----" ]]; then
      echo instalare atom
      echo $sudo_pass | sudo -S pacman -S --noconfirm atom
    fi
    echo $sudo_pass | sudo -S -u $user apm install color-picker emmet linter linter-cppcheck file-icons atom-ternjs atom-bootstrap3 pigments highlight-selected open-recent autocomplete-python platformio-ide-terminal atom-dark-fusion-syntax atom-material-ui seti-syntax linter-ui-default ide-php atom-ide-ui
      ;;


    "CargarSSH" )
    exit
    if [[ -e "~/.ssh/id_rsa" ]]; then
      echo cambiando permiso a tu llave
      chmod 700 ~/.ssh/id_rsa
      ssh-add ~/.ssh/id_rsa
    else
      echo no tienes una llave ssh debes generarla o copiar la que tenias en tu home
    fi
      ;;



    "PaquetesHuerfanos" )
    exit
    echo $sudo_pass | sudo -S pacman -Rnsc $(pacman -Qtdq)
    ;;



    "Configurargit")
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
}
# fin de declaracion de funciones

opcion="basura :v"

# instalamos todo aquello necesario
if [[ ! $val_zsh ]]; then
  aviso "Instalando zsh"
  echo $sudo_pass | sudo -S dnf install curl zsh zsh-syntax-highlighting -y
  echo $sudo_pass | sh -c "$(curl -fsSL ${config[ohmyzshurl]})"
  aviso "se ha instalado zsh"
fi

if [[ ! $val_oh_my_zsh ]]; then
  aviso "Instalando zsh"
  echo $sudo_pass | sh -c "$(curl -fsSL ${config[ohmyzshurl]})"
  aviso "se ha instalado oh ny zsh" true
fi

if [[ ! $val_python ]]; then
  aviso "Instalando python"
  echo $sudo_pass | sudo -S dnf install python-pip -y
  aviso "Python ahora esta instalado" true
fi

if [[ ! $val_pip ]]; then
  aviso "Instalando Pyton PIP"
  echo $sudo_pass | sudo -S dnf python-pip -y
  aviso "Python PIP esta instalado" true
fi

if [[ ! $val_git ]]; then
  aviso "Instalando git"
  echo $sudo_pass | sudo -S dnf git gitflow -y
  aviso "Git se ha instalado" true
fi


# pendiente
if [[ ! $val_code ]]; then
  aviso "Instalando vscode"
  # echo $sudo_pass | sudo -S dnf python-pip -y
  aviso "VsCode se ha instalado" true
fi



val_pip=$(pip -V)

if [ $1 ]; then
  # aca solo ejecutamos la opcion pasadap por argumento
  echo "okoko"
else
  while [[ $opcion != "" ]]; do 
    # imprimir opciones
    for opcion_numero in ${!opciones_indices[@]}
    do
      echo $opcion_numero
      echo ${opciones_indices[$opciones_numero]}
      echo ${opciones_indices[1]}
    done
    read opcion                                        

  done
fi



echo "saliendo del script"
