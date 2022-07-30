#!/bin/bash
: '
@Author Marco A Gallegos
@Date 2022-07-04
@Description
'
#funciones globales
aviso(){
	echo $1
}

# not execute nothing if is a bad platform
#primer paso validar version ubuntu
distro_text=$(grep "^NAME" /etc/os-release)
version_text=$(grep "^VERSION_ID" /etc/os-release)
IFS='=' # space is set as delimiter
# distro_text is read into an array as tokens separated by IFS
read -ra distro_arr <<< "$distro_text"
read -ra version_arr <<< "$version_text"

distro_name=${distro_arr[1]}
distro_version=${version_arr[1]}
# fedora_version_rpm=$(rpm -E %fedora)
desktop_envirenment=$DESKTOP_SESSION # variable de entorno

user=$(whoami)

if [[ $distro_name != '"Ubuntu"' && $distro_name != '"ubuntu"' ]]; then
	echo "this is not ubuntu"
	exit
fi


read -sp 'enter the sudo password:' sudo_pass
echo ""
if [[ ! $sudo_pass ]]; then
  aviso "necesito el pasword de sudo"
  exit
fi


declare -A config # especificamos que config es un array
config=(
    [ohmybashurl]='https://raw.github.com/ohmybash/oh-my-bash/master/tools/install.sh'
    [flutterurl]='https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.12.13+hotfix.5-stable.tar.xz'

    [composerbinpath]="export PATH=\$PATH:/home/$user/.config/composer/vendor/bin"
)


# prevent variable loading if not needed this takes a lot of time
# for now only if we not provide an arg we load all vars and tryu to install
if [[ ! $1 ]]; then

    # revisiones preliminares
    val_stow=$(stow --version)
    #instalaciones necesarias
    if [[ ! $val_stow ]]; then
	    echo $sudo_pass | sudo apt install stow -y
	    aviso "se instalo stow" true
    fi


    # el swapiness activo en el sistema
    val_swappines=$(cat /proc/sys/vm/swappiness)
    # este archivo almacena el valor swapiness editado por el usuario
    val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf )

    host_name=$(uname -n)
    val_graciasudo="basura :v"

    # librerias que se deben instalar
    #val_pythondevel=$(grep "python3-dev" ${config[rpmqafile]})

    # aplicaciones/etc que se deben instalar
    val_oh_my_bash=$(ls ~/.oh-my-bash/)
    val_python=$(python3 --version)
    val_pip=$(pip3 -V)
    val_git=$(git --version)
    val_php=$(php --version)
    val_composer=$(composer --version)
    val_node=$(node --version)
    val_npm=$(npm --version)
    # val_pm2=$(pm2 --version)
    val_nvim=$(nvim -v)

    # aplicaciones/librerias de python
    val_pip_tools=$(pip3 show pip-tools)
    # val_spyder=$(pip3 show spyder) # necesitas instalar libqtxdg
    val_docker=$(docker --version)

    # probando
    # pendiente

    # sdks
    # pendiente
    val_flutter=$(flutter --version)


    # instalamos todo aquello necesario
    if [[ ! $val_git ]]; then
        echo $sudo_pass | sudo -S apt install git gitflow -y
        aviso "Git se ha instalado" true
    fi

    if [[ ! $val_oh_my_bash ]]; then
        echo $sudo_pass | sh -c "$(curl -fsSL ${config[ohmybashurl]})"
        aviso "oh my bash is installed" true
    fi

    if [[ ! $val_pip || ! $val_python ]]; then
        echo $sudo_pass | sudo -S apt install python3-pip -y
    aviso "Python y/o PIP esta instalado" true
    fi

    if [[ ! $val_php ]]; then
        # https://rpmfusion.org/Configuration
        echo $sudo_pass | sudo apt -y install php-cli php-fpm php-mysql php-zip php-dev php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-json
        aviso "PHP is installed" true
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
        # use nvm instead
        #echo $sudo_pass | sudo apt -y install nodejs npm
        aviso "NodeJs/npm se ha instalado" true
    fi

    if [[ ! $val_docker ]];then
        #echo $sudo_pass | sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
        #echo $sudo_pass | sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
        #echo $sudo_pass | sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        #echo $sudo_pass | sudo apt update -y
        #echo $sudo_pass | sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose
        #echo $sudo_pass | sudo groupadd docker
        #echo $sudo_pass | sudo usermod -aG docker $user
        echo "WHIP"
    fi

    if [[ ! $val_flutter ]];then
        # https://flutter.dev/docs/get-started/install/linux
        # se debe instalar en /opt/flutter por convencion
        # echo $sudo_pass | sudo -S 
        # add here android sdk on linux steps
        aviso "flutter WIP" true
    fi

fi


if [[ $1 ]]; then
	case $1 in
		"update" )
            echo $sudo_pass | sudo apt clean -y
			echo $sudo_pass | sudo apt update -y
			echo $sudo_pass | sudo apt upgrade -y
			echo $sudo_pass | pip3 install --upgrade pip
		;;

		*)
			echo "opcion invalida: $1"
	esac
fi

