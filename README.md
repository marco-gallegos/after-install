# After Innstall

Scripts para montar de nuevo mi ambiente de trabajo instalando el software comun y configuracion


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


## react native install (no gui required on linux also works on mac)

### note

the adb configuration is also useful on flutter


### android studio or cmdline-tools (prefered)

install android studio better use snap store and thst it android studio handles everything you need (but needs a ui).

Or download cmdline tools from android studio alternative download, just scroll down (zip file) this doesnt requires ui, ex: you can use ssh

then add all this paths to allow anyone find sdk files downloaded

```shell
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
# zip from android studio page as alternative download
export PATH=$PATH:$ANDROID_HOME/cmdline-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
```

#### copy unziped download

```bash
# dont forget enable envs
source ~/.bashrc

# create folders
mkdir -p $ANDROID_HOME/cmdline-tools/

# moving downloaded unziped file
mv cmdline-tools $ANDROID_HOME/cmdline-tools/latest
```

#### instalar watchman (optional)

```shell
# fedora
sudo dnf copr enable eklitzke/watchman 

#ubuntu
sudo apt install watchman
```

#### some optional steps

```shell
nvim /etc/profile -> export PATH=$PATH:/var/lib/snapd/snap/bin
```


#### Connectiing cellphone using usb

now you only need conect phone and install platform tools

```shell
# use unziped content to install platform tools
sdkmanager --install platform-tools

# if env vars are ok then you can use adb now (from platform tools)
adb devices
```

if adb devices is not listing your device and permission is not requested on device, enable debug on phone and run this (tested on ubuntu not required after 2024)


```shell
setup device -> lsusb -> 4 digits (ID) from device on usb mode


# add rule:
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="{ID}", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android-usb.rules

# ej:
# echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2e04", MODE="0666", GROUP="plugdev"' | sudo tee /# etc/udev/rules.d/51-android-usb.rules

## try again
adb devices -> list devices
```


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

