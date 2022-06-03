#!/bin/zsh
: '
@Author Marco A Gallegos
@Date 2021-11-28
@Descripcion
	proveer instalaciones basicas para mac osx monterey
'
# system updates functions
system_updates() {
	brew update
	brew upgrade --greedy #greedy to update cask with non numerical version like 'latest' or 'master'
	pip install --upgrade pip
	git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull
	
	$HOME/.oh-my-zsh/tools/upgrade.sh
	#cleanup
	brew cleanup --prune=all -v
}


if [[ $1 && $1 = "update" ]]; then
	system_updates
	exit
fi

echo 'enter the sudo password:'
read -s sudo_pass
echo ''

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

# prevent variable loading if not needed this takes a lot of time
# for now only if we not provide an arg we load all vars and tryu to install
if [[ ! $1 ]]; then
	############################################################
	## variables catching
	val_git=$(git --version)
	val_brew=$(brew --version)
	val_iterm=$(git --version)
	val_oh_my_zsh=$(ls ~/.oh-my-zsh/)
	val_python=$(python3 --version)
	val_pip=$(pip3 -V)
	val_php=$(php --version)
	val_composer=$(composer --version)
	val_nvm=$(nvm --version)
	val_node=$(node --version)
	val_npm=$(npm --version)
	val_fuck=$(fuck --version)
	#to python development
	val_pip_tools=$(pip show pip-tools)

	#sdks
	val_flutter=$(flutter --version)
	val_android_studio=$(flutter --version)

	#############################################################
	## try to install missing values
	if [[ ! $val_git ]]; then
		brew install git git-flow
		aviso "Git se ha instalado" true
	fi

	## installing octave
	#brew tap octave-app/octave-app
	#brew install --cask octave-app
fi

if [[ $1 ]]; then
	case $1 in
		"update" )
			# redudant code but is good for now
			system_updates
		;;

		"rm_node_modules" )
			find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
		;;

		*)
			echo "invalid option: $1"
	esac
fi