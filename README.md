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