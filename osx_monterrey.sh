#!/usr/bin/ bash
: '
@Author Marco A Gallegos
@Date 2021-11-28
@Descripcion
	proveer instalaciones basicas para mac osx monterey
'
read -sp 'enter the sudo password:' sudo_pass
echo ""
if [[ ! $sudo_pass ]]; then
    aviso "necesito el pasword de sudo"
    exit
fi

user=$(whoami)

declare -A config # especificamos que config es un array
config=(
	[ohmyzshurl]='https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
	[homebrewurl]='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
)


val_git=$(git --version)
val_brew=$(git --version)
val_iterm=$(git --version)
val_oh_my_zsh=$(ls ~/.oh-my-bash/)
val_python=$(python3 --version)
val_pip=$(pip3 -V)
val_php=$(php --version)
val_composer=$(composer --version)
val_node=$(node --version)
val_npm=$(npm --version)


#to python development
val_pip_tools=$(pip3 show pip-tools)

#sdks
val_flutter=$(flutter --version)
val_android_studio=$(flutter --version)

# /bin/bash -c "$(curl -fsSL //url//)"

if [[ ! $val_git ]]; then
	echo $sudo_pass | sudo -S apt install git gitflow -y
	aviso "Git se ha instalado" true
fi

## installing octave
#brew tap octave-app/octave-app
#brew install --cask octave-app

if [[ $1 ]]; then
	case $1 in
		"update" )
			brew update
			sudo brew upgrade
			echo $sudo_pass | sudo pip3 install --upgrade pip 
            upgrade_oh_my_zsh
            git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull
		;;

		*)
			echo "opcion invalida: $1"
	esac
fi