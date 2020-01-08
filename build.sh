#!/bin/bash
: '
* @author Marco A Gallegos
* @date 2020-01-01
* @descripcion 
'

docker rm fedorafter
docker rmi fedorafter:0.1

#docker-compose up --build

docker build . -t fedorafter:0.1
docker run --name fedorafter -it fedorafter:0.1

# salir ctrl + p +q
# para ingresar a contenedor corriendo
# docker attach "nombre"
# docker attach fedorafter

# para ingresar a contenedor apagado
# docker start -i "nombre"
#docker start -i fedorafter