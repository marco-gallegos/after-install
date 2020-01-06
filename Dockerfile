FROM fedora

# no se usa MANTAINER en cambio label se usa para muchas metatags
LABEL maintainer="Marco A Gallegos"

RUN mkdir /app

# el directorio por defecto cuando entras en el contenedor
WORKDIR /app

# copia el primer parametro en local a el segundo parametro que es una carpeta del contenedor
ADD . /app

# RUN dnf install python -y

CMD [ "bash" ]
