#!/bin/bash
: '
* @author Marco A Gallegos
* @date 2020-01-01
* @descripcion 
'

docker build . -t fedorafter:0.1
docker run --name fedorafter -it fedorafter:0.1

# salir ctrl + p +q
# docker attach "nombre"