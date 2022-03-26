#!/bin/bash

: '
* @author Marco A Gallegos
* @date 2019-01-01
* @descripcion proveer opciones comunes para aligerar la instalacion o migracion de sistema operativo en este caso debian
'

## delete node modules
#find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +