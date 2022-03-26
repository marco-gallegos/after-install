#!/bin/zsh
: '
@Author Marco A Gallegos
@Date 2021-11-28
@Descripcion
	proveer instalaciones basicas para mac osx monterey
'
echo 'enter the sudo password:'
read sudo_pass
echo ""

if [[ ! $sudo_pass ]]; then
    echo "necesito el pasword de sudo"
    exit
fi

user=$(whoami)

#declare -A config # especificamos que config es un array
#config=(
#	[ohmyzshurl]='https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
#	[homebrewurl]='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
#)


val_git=$(git --version)
val_brew=$(brew --version)
val_iterm=$(git --version)
val_oh_my_zsh=$(ls ~/.oh-my-zsh/)
val_python=$(python3 --version)
val_pip=$(pip3 -V)
val_php=$(php --version)
val_composer=$(composer --version)
val_node=$(node --version)
val_npm=$(npm --version)
val_fuck=$(fuck --version)


#to python development
val_pip_tools=$(pip3 show pip-tools)

#sdks
val_flutter=$(flutter --version)
val_android_studio=$(flutter --version)

# /bin/bash -c "$(curl -fsSL //url//)"

if [[ ! $val_git ]]; then
	brew install git git-flow
	aviso "Git se ha instalado" true
fi

## installing octave
#brew tap octave-app/octave-app
#brew install --cask octave-app

if [[ $1 ]]; then
	case $1 in
		"update" )
			brew update
			brew upgrade
			pip3 install --upgrade pip
            git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull
			
			$HOME/.oh-my-zsh/tools/upgrade.sh
			#cleanup
			brew cleanup --prune=all -v
		;;

		"delete_node_modules" )
			find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
		;;

		*)
			echo "opcion invalida: $1"
	esac
fi