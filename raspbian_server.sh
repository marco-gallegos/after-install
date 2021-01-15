#!/bin/bash
: '
@Author Marco A Gallegos
@Date 2020-12-18
@Descripcion
	proveer instalaciones basicas para raspbian 10 como servidor
'
#funciones globales
aviso(){
	echo $1
}

read -sp 'enter the sudo password:' sudo_pass
echo ""
if [[ ! $sudo_pass ]]; then
  aviso "necesito el pasword de sudo"
  exit
fi

# revisiones preliminares
val_stow=$(stow --version)
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
val_pm2=$(pm2 --version)

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
	echo $sudo_pass | sudo apt -y install php php-cli php-fpm php-mysql php-zip php-dev php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-json
	aviso "PHP se ha instalado" true
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
	aviso "Composer se ha instalado cierra y abre tu terminal para ver los cambios reflejados"
fi

if [[ ! $val_node || ! $val_npm ]]; then
	echo $sudo_pass | sudo apt -y install nodejs npm
	aviso "NodeJs/npm se ha instalado" true
fi

if [[ ! $val_docker ]];then
	echo $sudo_pass | sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
	echo $sudo_pass | sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	echo $sudo_pass | sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
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
#if [ -f "${config[rpmqafile]}" ];then
#	echo $sudo_pass | sudo -S rm "${config[rpmqafile]}"
#fi

if [[ $1 ]]; then
	case $1 in
		"update" )
			echo $sudo_pass | sudo apt upgrade -y --refresh
			echo $sudo_pass | sudo pip install --upgrade pip
		;;

		*)
			echo "opcion invalida: $1"
	esac
fi

aviso "saliendo del script"
