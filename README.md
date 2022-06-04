<h1 align="center">BetHouse</h1>


# Contenidos 


- [Introducción](#introducción)
- [Construido con](#construido-con)
- [Primeros pasos](#primeros-pasos)
	- [Pre-requisitos](#pre-requisitos)
	- [Instalación](#instalaci%C3%B3n)
- [Base de datos](#base-de-datos)
	- [Modelo E-R](#modelo-e-r)
	- [Estructura de base de datos](#estructura-de-base-de-datos)
	- [Diagrama E-R](#diagrama-e-r)
- [Código](#código)
- [Roadmap](#roadmap)
- [Autores](#autores)

## Introducción
**BetHouse** es una Web Api para el trato de datos para una casa de apuestas. Esta interfaz ha sido diseñada para la comunicación entre el _Back End_ con cualquier tipo de _Front End_(cliente web, cliente móvil, etc). 
Parte del análisis de la base de datos fue hecha en colaboración con los compañeros de la FCT, la cuál permitirá hacer las siguientes operaciones de usuario y de administrador.

- Usuario:
	- Registro.
	- Inicio de sesión.
	- Ingreso de dinero.
	- Retiro de dinero.
	- Ver su saldo actual.
	- Ver los tipos de eventos, eventos y opciones de evento disponibles.
	- Hacer una apuesta.
	- Ver las apuestas realizadas.
	- Ver las transacciones realizadas.
- Administrador
	- Crear nuevo tipo de evento, evento y opciones de evento.
	- Cerrar un evento y realizar pagas a los usuarios ganadores.
	- Actualizar los multiplicadores de opciones de evento.


## Construido con
La estructura de este proyecto se ha creado con las siguientes herramientas:
- [Diagrams.net](https://app.diagrams.net)  Es un _software_  utilizado para diseñar diagramas de forma gratuita permite realizar cualquier tipo de diagrama de flujo.
- [Microsoft SQL Server](https://www.microsoft.com/es-es/sql-server/sql-server-downloads)  Es un sistema de gestión de base de datos relacional, desarrollado por la empresa Microsoft.
- [SQL Server Management Studio (SSMS)](https://docs.microsoft.com/es-es/sql/ssms/download-sql-server-management-studio-ssms?view)  Es un entorno integrado para administrar cualquier infraestructura de SQL, desde SQL Server a Azure SQL Database.
- [Microsoft Visual Studio](https://visualstudio.microsoft.com/es/downloads/)  Es un entorno de desarrollo integrado (IDE) para Windows y macOS. 
- [GitHub](https://github.com)  Es un sitio web y un servicio en la nube que ayuda a los desarrolladores a almacenar y administrar su código, al igual que llevar un registro y control de cualquier cambio sobre este código. Utilizando el control de versiones Git.
- [StackEdit](https://stackedit.io)  Es un completo editor de texto plano que te permite utilizar el lenguaje de marcado markdown para crear tus documentos.

## Primeros pasos

### Pre-requisitos
Para el desarrollo del proyecto se ha utilizado el siguiente IDE, instalarlo y abrir el proyecto:

>- [Microsoft Visual Studio](https://visualstudio.microsoft.com/es/downloads/)

### Instalación
1.	Clonar el repositorio de GitHub
	```sh 
	https://github.com/JGuilmar/ProyectoDAM
2.	Abrir el proyecto en el IDE y compilar el código. 

## Código
El código puede ser visto en el  [repositorio](https://github.com/JGuilmar/ProyectoDAM)

## Base de datos  
La base de datos está detallada de la siguiente manera:

### Modelo E-R
El siguiente Modelo E-R, hecho con [diagrams.net](https://app.diagrams.net) que sirvió para la base de este proyecto.


> ![Modelo E-R BetHouse](https://raw.githubusercontent.com/JGuilmar/ProyectoDAM/main/BaseDatos/Modelo%20E-R%20CasaApuestas.jpg)

### Estructura de base de datos
Las tablas en la base de datos tienen los atributos que se muestran a continuación, en la siguiente lista podemos ver el tipo de datos de cada tabla que usaremos:

#### Tabla Usuario

| Nombre de columna  | Tipo de dato SQL | Tipo de dato Visual Studio| Características|
| ------------- | ------------- | ------------- | ------------- |
| id_usuario  | int identity(1,1)| int| Primary Key|
| nombre  | varchar(255)  | string| not null|
| clave| varchar(255)| string| not null|
| saldo  | decimal(10,2)  | float| not null |

#### Tabla Tipo Evento
| Nombre de columna  | Tipo de dato SQL | Tipo de dato Visual Studio| Características|
| ------------- | ------------- | ------------- | ------------- |
| id_tipo_evento  | int identity(1,1)| int| Primary Key|
| nombre  | varchar(255)  | string| not null|
| descripción | varchar(255)| string| |

#### Tabla Evento

| Nombre de columna  | Tipo de dato SQL | Tipo de dato Visual Studio| Características|
| ------------- | ------------- | ------------- | ------------- |
| id_evento  | int identity(1,1)| int| Primary Key|
| nombre_evento  | varchar(255)  | string| not null|
| fecha | datetime| string| not null|
| id_tipo_evento  | int  | int | Foreign Key / not null |

#### Tabla Tipo de Transaccion

| Nombre de columna  | Tipo de dato SQL | Tipo de dato Visual Studio| Características|
| ------------- | ------------- | ------------- | ------------- |
| id_tipo_transaccion  | int identity(1,1)| int| Primary Key|
| nombre  | varchar(255)  | string| not null|
| descripción | varchar(255)| string|  |

#### Tabla Transaccion

| Nombre de columna  | Tipo de dato SQL | Tipo de dato Visual Studio| Características|
| ------------- | ------------- | ------------- | ------------- |
| id_transaccion  | int identity(1,1)| int| Primary Key|
| id_tipo_transaccion  | int  | int | Foreign Key / not null |
| fecha_transaccion | datetime  | string| not null|
| id_usuario  | int  | int | Foreign Key / not null |
| monto  | decimal(10,2)  | float| not null |
| saldo_inicial  | decimal(10,2)  | float| not null |
| saldo_final  | decimal(10,2)  | float| not null |

#### Tabla Opcion

| Nombre de columna  | Tipo de dato SQL | Tipo de dato Visual Studio| Características|
| ------------- | ------------- | ------------- | ------------- |
| id_opcion  | int identity(1,1)| int| Primary Key|
| id_evento  | int  | int | Foreign Key / not null |
| nombre_opcion | varchar(255)  | string| not null|
| multiplicador  | decimal(10,2)  | float| not null |
| ganador  | bit  | bool | not null |

#### Tabla Apuesta

| Nombre de columna  | Tipo de dato SQL | Tipo de dato Visual Studio| Características|
| ------------- | ------------- | ------------- | ------------- |
| id_apuesta  | int identity(1,1)| int| Primary Key|
| id_usuario  | int  | int | Foreign Key / not null |
| id_opcion  | int  | int | Foreign Key / not null |
| fecha_apuesta | datetime  | string| not null|
| cantidad  | decimal(10,2)  | float| not null |
| multiplicador  | decimal(10,2)  | float| not null |
| id_transaccionP  | int  | int | Foreign Key / not null |
| id_transaccionC  | int  | int | Foreign Key / not null |

#### Tabla Codigos Error

| Nombre de columna  | Tipo de dato SQL | Tipo de dato Visual Studio| Características|
| ------------- | ------------- | ------------- | ------------- |
| codigo  | int | int| not null|
| descripcion  | varchar(255)  | string| not null|


### Diagrama E-R
El siguiente Diagrama E-R, se generó por la creación de las tablas desde [SQL Server Management Studio (SSMS)](https://docs.microsoft.com/es-es/sql/ssms/download-sql-server-management-studio-ssms?view).
> ![Diagrama E-R BetHouse](https://raw.githubusercontent.com/JGuilmar/ProyectoDAM/main/BaseDatos/Diagrama_Betit_CasaApuestas.PNG)

## Roadmap
- [x] Análisis del problema
- [x] Diseño de un Modelo E-R.
- [x] Implementación de la estructura de la base de datos.
- [x] Llenado de las tablas de las base de datos con datos harcodeados.
- [x] Creación de los procedimientos  en SQL para el funcionamiento de la Web API.
- [x] Creación de la clase en **c#** de la conexión a la base de datos.
- [x] Creación de los controllers en **c#** para Usuario y Administrador de la Web API.
- [x] Pruebas del funcionamiento del programa.
- [x] Documentación. 

## Autores
-   **Jose Bayona** - [Jose Bayona](https://github.com/JGuilmar)
