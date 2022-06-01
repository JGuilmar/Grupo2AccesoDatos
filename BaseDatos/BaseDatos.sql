CREATE DATABASE BetHouse
CREATE LOGIN [bayonaJose] WITH PASSWORD='abc12345..', DEFAULT_DATABASE=[BetHouse]
GO
USE [BetHouse]
CREATE USER [bayonaJose] FOR LOGIN [bayonaJose]
ALTER ROLE [db_owner] ADD MEMBER [bayonaJose]

/** Creacion de tablas**/

drop table USUARIO
CREATE TABLE USUARIO(
	id_usuario INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL UNIQUE,
	clave VARCHAR(255) NOT NULL,
	saldo DECIMAL(10,4) NOT NULL
	)

Select * from usuario where nombre = 'Usuario6'

CREATE TABLE TIPO_EVENTO(
	id_tipo_evento INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL UNIQUE,
	descripcion VARCHAR(255)
	)

Select * from TIPO_EVENTO

CREATE TABLE EVENTO(
	id_evento int identity(1,1) primary key,
	nombre_evento varchar(255) not null,
	fecha datetime not null,
	id_tipo_evento int not null references TIPO_EVENTO(id_tipo_evento),
	)

Select * from EVENTO

CREATE TABLE TIPO_TRANSACCION(
	id_tipo_transaccion INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL UNIQUE,
	descripcion VARCHAR(255)
	)

Select * from TIPO_TRANSACCION

CREATE TABLE TRANSACCION(
	id_transaccion INT IDENTITY(1,1) PRIMARY KEY,
	id_tipo_transaccion INT NOT NULL REFERENCES TIPO_TRANSACCION(id_tipo_transaccion),
	fecha_transaccion DATETIME NOT NULL,
	id_usuario INT NOT NULL REFERENCES USUARIO(id_usuario),
	monto DECIMAL(10,3) NOT NULL,
	saldo_inicial DECIMAL(10,3) NOT NULL,	
	saldo_final DECIMAL(10,3) NOT NULL,
	)

Select * from TRANSACCION

CREATE TABLE OPCION(
	id_opcion INT IDENTITY(1,1) PRIMARY KEY,
	id_evento INT NOT NULL REFERENCES EVENTO(id_evento),
	nombre_opcion VARCHAR(255),
	multiplicador DECIMAL(10,3) NOT NULL,
	ganador bit
)

Select * from OPCION

CREATE TABLE APUESTA(
	id_apuesta INT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL REFERENCES USUARIO(id_usuario),
	id_opcion INT NOT NULL REFERENCES OPCION(id_opcion),
	fecha_apuesta DATETIME NOT NULL,
	cantidad DECIMAL(10,3) NOT NULL,
	multiplicador DECIMAL(10,3) NOT NULL,
	id_transaccionP INT NOT NULL REFERENCES TRANSACCION(id_transaccion),
	id_transaccionC INT REFERENCES TRANSACCION(id_transaccion),
)

Select * from APUESTA

CREATE TABLE CODIGOS_ERROR(
	codigo INT NOT NULL,
	descripcion VARCHAR(255) NOT NULL
)

Select * from CODIGOS_ERROR

/** LLENADO DE TABLAS **/
/** TABLAS HARCODEADAS **/
INSERT INTO USUARIO(nombre,clave,saldo) 
VALUES  ('Usuario1','abc123456',40),
		('Usuario2','abc123456',30),
		('Usuario3','abc123456',0),
		('Usuario4','abc123456',10.50),
		('Usuario5', 'abc123456', 50), 
		('Usuario6', 'abc123456', 34)

INSERT INTO TIPO_EVENTO(nombre,descripcion) 
VALUES	('Futbol once','11 vs 11'),
		('Tenis','1 vs 1'),
		('Carrera de caballos','12 caballos'),
		('Formula 1','20 coches')

INSERT INTO evento(nombre_evento,fecha,id_tipo_evento) 
VALUES	('Madrid vs Barcelona','2022-05-25T15:00:00',1),
		('Deportivo vs Sevilla','2022-05-25T16:00:00',1),
		('Nadal vs Federer','2022-06-25T17:00:00',2),
		('Djocovik vs Pepe','2022-06-25T18:00:00',2),
		('Carrera Premium2','2022-06-25T20:00:00',3),
		('Gran Premio Catar','2022-06-25T20:00:00',4)


INSERT INTO TIPO_TRANSACCION(nombre,descripcion) 
VALUES	('Ingreso', 'El usuario ingresa dinero para su apuesta'),
		('Retiro', 'El usuario retira dinero de una apuesta ganada'),
		('Apuesta Realizada', 'El usuario realiza una apuesta'),
		('Apuesta Ganada', 'El usuario gana una apuesta')
 
INSERT INTO TRANSACCION(id_tipo_transaccion, fecha_transaccion, id_usuario, monto, saldo_inicial, saldo_final) 
VALUES  (1, '2022-03-01 21:00', 5, 20, 0, 20),
		(2, '2022-03-11 10:55', 4, 50, 62, 12),
		(1, '2022-03-11 10:55', 3, 15, 5, 20),
		(4, '2022-03-17 10:55', 1, 75, 0, 75),
		(3, '2022-03-23 10:55', 5, 15, 20, 5),
		(2, '2022-03-23 10:55', 6, 55, 55, 0),
		(1, '2022-03-24 10:55', 4, 20, 12, 32),
		(3, '2022-04-02 10:55', 2, 20, 20, 0),
		(1, '2022-04-06 10:55', 4, 8, 32, 40),
		(4, '2022-04-07 14:10', 3, 50, 20, 70)

INSERT INTO OPCION(id_evento,nombre_opcion,multiplicador,ganador)
values  (1,'Madrid', 2.32, NULL), (1, 'Barcelona', 2.54, NULL),(2,'Empate',1.94,NULL),
 		(2,'Deportivo',3,NULL),(2,'Sevilla',1.1,NULL),(2,'Empate',1.94,NULL),(2,'Empate',1.94,NULL),
		(3,'Nadal',1.2,NULL),(3,'Federer',1.9,NULL),
		(4,'Djocovik',1.01,NULL),(4,'Pepe',11,NULL),
		(5,'10',4,NULL),(5,'11',5,NULL),(5,'12',7,NULL),(5,'13',5,NULL),(5,'14',5,NULL),(5,'15',5,NULL),
		(5,'16',5,NULL),(5,'17',8,NULL),(5,'18',9,NULL),(5,'19',10,NULL),(5,'20',22,NULL),(5,'21',26,NULL),
		(6,'Verstappen',4,NULL),(6,'Leclerc',5,NULL),(6,'Sainz',7,NULL),(6,'Perez',5,NULL),(6,'Russell',5,NULL),(6,'Ocon',5,NULL),
		(6,'Norris',5,NULL),(6,'Gasly',8,NULL),(6,'Magnussen',9,NULL),(6,'Hamilton',2,NULL),(6,'Zhou',22,NULL),(6,'Hulkenberg',26,NULL),
		(6,'Stroll',4,NULL),(6,'Albon',5,NULL),(6,'Bottas',7,NULL),(6,'Alonso',5,NULL),(6,'Ricciardo',5,NULL),(6,'Latifi',5,NULL),(6,'Tsunoda',5,NULL)


INSERT INTO APUESTA(id_usuario, id_opcion, fecha_apuesta, cantidad, multiplicador, id_transaccionP, id_transaccionC) 
values  (1, 1, '2022-05-22T19:30:00', 20, 2.3, 3, 4),
		(1, 2, '2022-05-24T18:00:00', 40, 2.5, 4, null),
		(3, 7, '2022-03-01T00:00:00', 100, 1.64, 7, NULL)

drop table CODIGOS_ERROR
INSERT INTO CODIGOS_ERROR(codigo, descripcion) 
values  (0, 'Correcto'),
		(1, 'Usuario ya registrado'),
		(2, 'Datos incorrectos'),
		(3, 'Saldo insuficiente'),
		(4, 'Evento cerrado'),
		(5, 'Usuario no registrado'),
		(6, 'Falta que se realice evento') 


Select * from usuario
Select * from TIPO_EVENTO
Select * from EVENTO
Select * from TIPO_TRANSACCION
Select * from TRANSACCION
Select * from EVENTO
Select * from OPCION
Select * from APUESTA
Select * from CODIGOS_ERROR