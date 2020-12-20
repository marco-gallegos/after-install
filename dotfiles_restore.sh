#!/bin/bash
: '
@author Marco A Gallegos
@Date 2020/12/18
@Descripcion
    Este script debe tomar los backckups "archivo.ext.back" que genero nuetro script
    "safe_dotfiles_adopt.sh" 
Tested on: 
* fedora 32
'

dotfiles=(
    "bash" "alacritty" "htop"
)

declare -A context_of_original_files # especificamos que es un array
context_of_original_files=(
    [bash]="$HOME"
    [alacritty]="$HOME"
    [htop]="$HOME"
)

declare -A original_files # especificamos que es un array
original_files=(
    [bash]="/.bashrc"
    [alacritty]="/.config/alacritty/alacritty.yml"
    [htop]="/.config/htop/htoprc"
)


for i in ${dotfiles[@]}
do
    # backup
    if [[ -f "${context_of_original_files[$i]}${original_files[$i]}.bak" ]]; then
        rm -v "${context_of_original_files[$i]}${original_files[$i]}"
        cp -v "${context_of_original_files[$i]}${original_files[$i]}.bak" "${context_of_original_files[$i]}${original_files[$i]}"
    else
        echo "No tenemos respaldo de $i"
    fi
done
