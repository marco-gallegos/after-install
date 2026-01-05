# After Innstall

Scripts para montar de nuevo mi ambiente de trabajo instalando el software comun y configuracion

## Dependencias

* zenity
* stow


## To Do

- [ ] git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"


###### Soporte para : 

* manjaro / arch linux
* fedora
* raspbian
* debian
* mac

##### algunas herramientas y cli

* [the fuck](https://github.com/nvbn/thefuck)
* neovim
  * vim plug
* [docker pretty ps](https://github.com/politeauthority/docker-pretty-ps)
* [commitcli](https://link)
* [gibo](https://github.com/simonwhitaker/gibo)
* [npmcheckupdates](https://github.com/raineorshine/npm-check-updates) npm install -g npm-check-updates
* brew install planetscale/tap/pscale
* 

## dotfiles

### agregar
mkdir "modulo"
mkdir -r "ruta completa"
touch "modulo"/"ruta completa"/"archivo"
stow --adopt -vt "directorioraiz" "modulo"

ejemplo:

stow --adopt -vnt ~ bash

### desvincular

esto no recrea el archivo solo elimina el enlace dejandote sin archivo.

stow -Dv -t "directorioraiz" "modulo"

ejemplo:

stow -Dv -t ~ bash

## recursos

7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on $directorio_destino/http.7z origen


## react native install

### note

the adb configuration is also useful on flutter

install android studio -> use snap store

```shell
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
# zip from android studio page as alternative download
export PATH=$PATH:$ANDROID_HOME/cmdline-tools
```

### copy unziped download

```bash
mv cmdline-tools $ANDROID_HOME/cmdline-tools/latest
```

instalar watchman

sudo dnf copr enable eklitzke/watchman 

nvim /etc/profile -> export PATH=$PATH:/var/lib/snapd/snap/bin

setup device -> lsusb -> 4 digits (ID) from device on usb mode


add rule:

echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="{ID}", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android-usb.rules

adb devices -> list devices

ej:
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2e04", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android-usb.rules

check usb debugging on true on device
now can see

## netcore en fedora 32

sudo dnf install aspnetcore-runtime-3.1-3.1.1 dotnet-sdk-3.1

go get github.com/nishanths/license



## gp firmar commits

gpg --list-keys

gpg --full-generate-key

git config --global user.signingkey <idkey>

git config --global user.signingkey ->  si el valor esta vacio no hay configuracion

como ver la signature en mi formato de log / mi git lg



sudo apt-get install netselect-apt

sudo netselect-apt

genera un source list que se copia a


## raspbian mongo

wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

sudo apt update


sudo apt install -y mongodb-org=4.2 mongodb-org-server=4.2 mongodb-org-shell=4.2 mongodb-org-mongos=4.2 mongodb-org-tools=4.2

no corre por falta de libc6 mas nueva usar docker
https://www.bmc.com/blogs/mongodb-docker-container/

sudo apt install r-base-core r-base


## mongo fedora

sudo echo "[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1

gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc" > /etc/yum.repos.d/mongodb-org-4.4.repo

