# init api and monolithic

Objetivo (rutas api vista con vue):

Crear un CRUD de empleados con el Framework (Laravel) (ultima version) el diseño de la interfaz, la
arquitectura y diseño de la aplicación es abierta.


Crear un nuevo proyecto en Laravel y activar el login por
defecto de Laravel con vue.js.

Generar la migración para la tabla de empleados utilizando los siguientes campos: id,
código, nombre, apellido paterno, apellido materno, correo electrónico, tipo de
contrato, estado (Activo o inactivo)

Crear un listado privado de todos los empleados registrados en la tabla creada
anteriormente pero omitiendo empleados eliminados, agregar botón para agregar un
nuevo empleado, además, el listado debe contener una columna con acciones de ver
detalle, editar, activar/desactivar y eliminar.

Las acciones de creación y edición deberán de validar durante el envio del formulario el
campo de correo electrónico (tipo email), nombre y apellidos (no debe permitir
números pero si guiones) desde Laravel si las validaciones son correctas se deberá
guardar o actualizar la información en la base de datos

Funcionalidad para activar o desactivar un empleado

Realizar eliminación lógica

Vista para ver información por empleado.

plus : Realizar pruebas unitarias del CRUD, Arquitectura escalable y mantenible,
comentarios en código.


## lista compacta

* dd
* 

## intro 

## 1

laravel new nomina_new


se debe usar breeze pues es lo nuevo

composer require laravel/breeze --dev
php artisan breeze:install
npm install --save-dev vue
npm install && npm run watch

hasta aca el login funciona

resta hacer lo de vue

resources/js/app.js

```javascript
import Vue from 'vue';
import App from './components/app.vue'

window.Vue = Vue;


const app = new Vue({
    el:"#app",
    components:{
        App
    }
})
```


resources/js/components/app.js
```javascript
<template>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card text-left">
                    <div class="card-body">
                        <h4 class="card-title">Title</h4>
                        <p class="card-text">Body</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    mounted(){
        console.log("beep beep bop")
    },
    data(){
        return {
        }
    }
}
</script>
```