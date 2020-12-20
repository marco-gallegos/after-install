#!/bin/bash
: '
@author Marco A Gallegos
@Date 2020/12/18
@Descripcion
    este archivo debe hacer un backup de los archivos originales de los dotfiles configurados
    solo si no existe alguno, despues se debe usar el stow sobre los dotfiles.
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
        echo "ya tenemos respaldo de $i"
    else
        #echo "${original_files[$i]}" "${original_files[$i]}.bak"
        cp -v "${context_of_original_files[$i]}${original_files[$i]}" "${context_of_original_files[$i]}${original_files[$i]}.bak"
        if [[ -f "${context_of_original_files[$i]}${original_files[$i]}.bak" ]]; then
            echo "se creo el respaldo de $i"
        fi
    fi
    
    rm -v "${context_of_original_files[$i]}${original_files[$i]}"

    # stow
    stow --adopt -vt ${context_of_original_files[$i]} $i
done
