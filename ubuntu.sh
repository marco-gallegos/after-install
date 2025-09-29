#!/bin/bash
: '
@Author Marco A Gallegos
@Date 2022-07-04
@Description
'
#funciones globales
aviso() {
  echo $1
}

# not execute nothing if is a bad platform
#primer paso validar version ubuntu
distro_text=$(grep "^NAME" /etc/os-release)
version_text=$(grep "^VERSION_ID" /etc/os-release)
IFS='=' # space is set as delimiter
# distro_text is read into an array as tokens separated by IFS
read -ra distro_arr <<<"$distro_text"
read -ra version_arr <<<"$version_text"

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
  val_swap=$(grep "vm.swappines" /etc/sysctl.d/99-sysctl.conf)

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

  if [[ ! $val_docker ]]; then
    #echo $sudo_pass | sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    #echo $sudo_pass | sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    #echo $sudo_pass | sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    #echo $sudo_pass | sudo apt update -y
    #echo $sudo_pass | sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose
    #echo $sudo_pass | sudo groupadd docker
    #echo $sudo_pass | sudo usermod -aG docker $user
    echo "WHIP"
  fi

  if [[ ! $val_flutter ]]; then
    # https://flutter.dev/docs/get-started/install/linux
    # se debe instalar en /opt/flutter por convencion
    # echo $sudo_pass | sudo -S
    # add here android sdk on linux steps
    aviso "flutter WIP" true
  fi

fi

VscodeExtensions() {
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
  # code --install-extension coenraads.bracket-pair-colorizer-2 -> built in in newest versions
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
}

VscodiumExtensions() {
  codium --install-extension ms-python.python
  codium --install-extension ritwickdey.liveserver
  codium --install-extension visualstudioexptteam.vscodeintellicode
  codium --install-extension ms-azuretools.vscode-docker
  codium --install-extension octref.vetur
  codium --install-extension pkief.material-icon-theme
  codium --install-extension felixfbecker.php-intellisense
  codium --install-extension redhat.vscode-yaml
  codium --install-extension xabikos.javascriptsnippets
  codium --install-extension formulahendry.auto-rename-tag
  codium --install-extension golang.go
  codium --install-extension christian-kohler.path-intellisense
  codium --install-extension formulahendry.auto-close-tag
  codium --install-extension zignd.html-css-class-completion
  codium --install-extension naumovs.color-highlight
  codium --install-extension dsznajder.es7-react-js-snippets
  codium --install-extension yzhang.markdown-all-in-one
  # codium --install-extension coenraads.bracket-pair-colorizer-2 -> built in in new versions
  codium --install-extension oderwat.indent-rainbow
  codium --install-extension mikestead.dotenv
  codium --install-extension thekalinga.bootstrap4-vscode
  codium --install-extension onecentlin.laravel-blade
  codium --install-extension mhutchie.git-graph
  codium --install-extension mechatroner.rainbow-csv
  codium --install-extension gruntfuggly.todo-tree
  codium --install-extension onecentlin.laravel5-snippets
  codium --install-extension orta.vscode-jest
  codium --install-extension pivotal.vscode-boot-dev-pack
  codium --install-extension njpwerner.autodocstring
  codium --install-extension cjhowe7.laravel-blade
  codium --install-extension ms-dotnettools.csharp

  ## news not sure if exist on vscode
  codium --install-extension mads-hartmann.bash-ide-vscode
  codium --install-extension tamasfe.even-better-toml
}

DbBackup() {

}

if [[ $1 ]]; then
  ## some vars to update system

  val_nala=$(nala --version)
  val_uv=$(uv --version)
  # val_nvm=$(nvm --version)
  val_node=$(node --version)
  val_rustup=$(rustup --version)
  val_snap=$(snap --version)

  case $1 in
  "update")
    echo $sudo_pass | sudo apt clean -y

    if [[ -n "$val_nala" ]]; then
      echo $sudo_pass | sudo nala upgrade --full -y
      #echo "nala plcaeholder"
    else
      echo $sudo_pass | sudo apt update -y
      echo $sudo_pass | sudo apt upgrade -y
    fi

    if [[ -n "$val_uv" ]]; then
      uv self update
    fi

    # if [[ -n "$val_nvm" ]]; then
    #     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    # fi

    if [[ -n "$val_node" ]]; then
      npm update -g
    fi

    if [[ -n "$val_rustup" ]]; then
      rustup update
    fi

    if [[ -n "$val_snap" ]]; then
      echo $sudo_pass | sudo snap refresh
    fi
    ;;

  "code-extensions")
    VscodeExtensions
    ;;

  "codium-extensions")
    VscodiumExtensions
    ;;

  "dbbackup")
    DbBackup
    ;;

  *)
    echo "opcion invalida: $1"
    ;;
  esac
fi
