# After Innstall

Scripts para montar de nuevo mi ambiente de trabajo instalando el software comun y 

## Dependencias

* zenity
* stow


## To Do

- [ ] rsync backups


###### Soporte para : 

* manjaro / arch linux
* fedora
* raspbian


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

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

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


npm i -g semantic-git-commit-cli

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
