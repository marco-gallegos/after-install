#!/bin/bash
: '
@Author Marco A Gallegos
@Date 2020-12-18
@Descripcion
	proveer instalaciones basicas para raspbian 10 como servidor
'

# revisiones preliminares
$val_stow=$(stow --version)
#instalaciones necesarias
if [[ ! $val_stow ]]; then
	echo $sudo_pass | sudo apt install stow -y
	aviso "se instalo stow" true
fi


#primer paso validar que sea fedora en version 32 o superior
distro_text=$(grep "^NAME" /etc/os-release)
version_text=$(grep "^VERSION_ID" /etc/os-release)
IFS='=' # space is set as delimiter
read -ra distro_arr <<< "$distro_text" # distro_text is read into an array as tokens separated by IFS
read -ra version_arr <<< "$version_text"


distro_name=${distro_arr[1]}
distro_version=${version_arr[1]}
#fedora_version_rpm=$(rpm -E %fedora)
desktop_envirenment=$DESKTOP_SESSION # variable de entorno

#if [[ $distro_name != "Fedora" && $distro_name != "fedora" ]] || [[ $distro_version < 32 ]]#; then
#	echo "no es una distro fedora soportada"
#	exit
#else
#	echo "distro soportada"
#fi

user=$(whoami)

declare -A config # especificamos que config es un array
config=(
	[flutterurl]='https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.5-stable.tar.xz'

	[rpmqafile]='rpmqa.txt'
	[composerbinpath]="export PATH=\$PATH:/home/$user/.config/composer/vendor/bin"
)

#sudo_pass=$(zenity --password --title="contraseña sudo")
#if [[ ! $sudo_pass ]]; then
#  aviso "necesito el pasword de sudo" true
#  exit
#fi

# solo ejecutamos rpm -qa 1 vez por que es lento lo mandamos a un archivo y luego solo hacemos grep a este
#if [ -f "${config[rpmqafile]}" ];then
#	echo $sudo_pass | sudo -S rm "${config[rpmqafile]}"
#fi
#rpm -qa > "${config[rpmqafile]}"

# el swapiness activo en el sistema
val_swappines=$(cat /proc/sys/vm/swappiness)
# este archivo almacena el valor swapiness editado por el usuario
val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )

host_name=$(uname -n)
val_graciasudo="basura :v"

# librerias que se deben instalar
#val_pythondevel=$(grep "python3-dev" ${config[rpmqafile]})

# aplicaciones/etc que se deben instalar
# TODO testear
val_oh_my_bash=$(ls ~/.oh-my-bash/)
val_python=$(python3 --version)
val_pip=$(pip3 -V)
val_git=$(git --version)
val_php=$(php --version)
val_composer=$(composer --version)
val_node=$(node --version)
val_npm=$(npm --version)

# aplicaciones/librerias de python
val_pip_tools=$(pip3 show pip-tools)
val_spyder=$(pip3 show spyder) # necesitas instalar libqtxdg

# probando
val_docker=$(docker --version)
# pendiente

#sdks
# pendiente
val_flutter=$(flutter --version)

# auxiliar para mostrar tanto notificaciones push como logs
aviso() {
	echo "$1"
}

# instalamos todo aquello necesario
if [[ ! $val_git ]]; then
	echo $sudo_pass | sudo -S apt install git gitflow -y
	aviso "Git se ha instalado" true
fi

#if [[ ! $val_oh_my_zsh ]]; then
#  echo $sudo_pass | sh -c "$(curl -fsSL ${config[ohmyzshurl]})"
#  aviso "se ha instalado oh my zsh" true
#fi

if [[ ! $val_pip || ! $val_python ]]; then
	echo $sudo_pass | sudo -S apt install python3-pip -y
aviso "Python y/o PIP esta instalado" true
fi

if [[ ! $val_php ]]; then
	# https://rpmfusion.org/Configuration
	echo $sudo_pass | sudo apt -y install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
	aviso "PHP se ha instalado" true
fi

if [[ ! $val_composer ]]; then
	# https://rpmfusion.org/Configuration
	echo $sudo_pass | sudo apt -y install composer
	existe_path=$(grep "${config[composerbinpath]}" /etc/profile)
	if [[ ! $existe_path ]]; then
		echo $sudo_pass | sudo -S sed -i "\$a ${config[composerbinpath]}" /etc/profile
	fi
	source /etc/profile
	aviso "Composer se ha instalado cierra y abre tu terminal para ver los cambios reflejados" true
fi

if [[ ! $val_node || ! $val_npm ]]; then
	echo $sudo_pass | sudo apt -y install nodejs npm
	aviso "NodeJs/npm se ha instalado" true
fi

if [[ ! $val_docker ]];then
	echo $sudo_pass | sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
	echo $sudo_pass | curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	echo $sudo_pass | sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/debian$(lsb_release -cs)stable"
	echo $sudo_pass | sudo apt update -y
	echo $sudo_pass | sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose
	echo $sudo_pass | sudo groupadd docker
	echo $sudo_pass | sudo usermod -aG docker $user
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


case $opcion in
	"update" )
		echo $sudo_pass | sudo apt upgrade -y --refresh
		echo $sudo_pass | sudo pip install --upgrade pip
	;;
#	
#	"Actualizar++" )
#	echo $sudo_pass | sudo apt clean all && sudo apt upgrade -y --refresh
#	echo $suco_pass | sudo -S snap refresh 
#	echo $sudo_pass | sudo -S flatpak update
#	echo $sudo_pass | sudo -S npm update -g
#	composer global update
#	echo $sudo_pass | sudo -S pip install --upgrade pip
#	#sh $ZSH/tools/upgrade.sh
#	;;
#
#	"Migracion" )
#	echo "WIP"
#	exit
#	directorio_destino=$(zenity --file-selection --directory --title="Directorio de #destino para el respaldo")
#	directorio_destino+="/"
#	directorio_destino+=$host_name
#	mkdir $directorio_destino
#	directorio_destino+="/"
#	directorio_destino+=$user
#	mkdir $directorio_destino
#	cp -R $HOME/.ssh $directorio_destino
#	echo $sudo_pass | sudo -S 7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on #$directorio_destino/http.7z /srv/http
#	for x in `ls $HOME`;
#	do
#	cp -R $HOME/$x $directorio_destino;
#	done
#	aviso "respaldo terminado"
#	  ;;
#
#	"Limpiar" )
#	echo $sudo_pass | sudo apt clean all
#	  ;;
#
#	"Software" )
#	echo $sudo_pass | sudo apt install -y stacer vlc
#	bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"
#	  ;;
#
#	"IDES" )
#	aviso "No implementado" true
#	exit
#	echo $sudo_pass | sudo apt install 
#	  ;;
#
#
#	"Swappiness" )
#	exit
#	if [[ -e "/etc/sysctl.d/99-sysctl.conf" ]]; then
#	  echo existe
#	else
#	  echo creando
#	  echo $sudo_pass | sudo -S touch /etc/sysctl.d/99-sysctl.conf
#	fi
#	val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )
#	echo $sudo_pass | sudo -S cp /etc/sysctl.d/99-sysctl.conf /etc/sysctl.d/99-sysctl.conf.#old
#
#	echo dame el valor para asignar
#	read val_asignar_swap
#
#	if [[ ${val_swap[0]} == "" ]]; then
#	  echo $sudo_pass | sudo -s "echo vm.swappiness=$val_asignar_swap >> /etc/sysctl.d/#99-sysctl.conf"
#	else
#	  echo $sudo_pass | sudo -S sed -i "s%${val_swap[0]}%vm.#swappiness=$val_asignar_swap%g" /etc/sysctl.d/99-sysctl.conf
#	fi
#	  ;;
#
#
#	"Complementos ATOM" )
#	exit
#	if [[ $val_apm == "---- No tienes instalado atom -----" ]]; then
#	  echo instalare atom
#	  echo $sudo_pass | sudo -S pacman -S --noconfirm atom
#	fi
#	echo $sudo_pass | sudo -S -u $user apm install color-picker emmet linter #linter-cppcheck file-icons atom-ternjs atom-bootstrap3 pigments highlight-selected #open-recent autocomplete-python platformio-ide-terminal atom-dark-fusion-syntax #atom-material-ui seti-syntax linter-ui-default ide-php atom-ide-ui
#	  ;;
#
#
#	"Cargar SSH" )
#	exit
#	if [[ -e "~/.ssh/id_rsa" ]]; then
#	  echo cambiando permiso a tu llave
#	  chmod 700 ~/.ssh/id_rsa
#	  ssh-add ~/.ssh/id_rsa
#	else
#	  echo no tienes una llave ssh debes generarla o copiar la que tenias en tu home
#	fi
#	  ;;
#
#	"Paquetes Huerfanos" )
#	exit
#	echo $sudo_pass | sudo -S pacman -Rnsc $(pacman -Qtdq)
#	;;
#
#	"Configurar git")
#	echo "cual es tu nombre : "
#	read nombre_git
#	echo "cual es tu email  : "
#	read email_git
#	echo "editor para los commits : "
#	read editor_git""
#	git config --global user.name "$nombre_git"
#	git config --global user.email "$email_git"
#	git config --global core.editor "$editor_git"
#	git config color.ui true
#	;;
#
#	"Utilidades DE")
#	exit 0
#	if [[ $desktop_envirenment -eq "xfce" ]]; then
#	  echo $sudo_pass | sudo apt install xfce4-xkb-plugin xfce4-screensaver #xfce4-panel-profiles xfce-theme-manager thunar-archive-plugin
#	fi
#
#	if [[ $desktop_envirenment -eq "gnome" ]]; then
#	  aviso "No uses Gnome" true
#	fi
#
#	;;
#
#	"Temas, Iconos")
#	  aviso "Aun no implementado" true
#	;;
#
#	"Bootsplash" )
#	exit
#	;;
esac

done

echo "saliendo del script"