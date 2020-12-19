#!/bin/bash
: '
@author Marco A Gallegos
@Date 2020/12/18
@Descripcion
    Este archivo debe restaurar los dotfiles que se tengan configurados, esto pensando en que ya no quieres usar stow
'

dotfiles=(
    "bash" "alacritty"
)

declare -A original_files # especificamos que es un array
original_files=(
    [bash]="$HOME/.bashrc"
    [alacritty]="$HOME/.config/alacritty/alacritty.yml"
)

for i in ${dotfiles[@]}
do
    #echo "${original_files[$i]}" "${original_files[$i]}.bak"
    cp -v "${original_files[$i]}" "${original_files[$i]}.bak"
    rm -v "${original_files[$i]}"
done
