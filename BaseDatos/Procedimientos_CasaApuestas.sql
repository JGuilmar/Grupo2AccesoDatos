/**
 *
	PROCEDIMIENTOS PARA EL USUARIO
									*
									**/

/** 
	Registro de un usuario 
							**/

Go 
create procedure registroUsuario
	@usuario varchar(255),
	@clave varchar(255)
as
	declare @codigoError int
	set @codigoError = 0
	--Verificamos si el usuario esta registrado
	if(select count(*) from usuario where nombre = @usuario) = 0
		insert into USUARIO(nombre, clave, saldo) values (@usuario, @clave, 0)
	else
		set @codigoError = 1
	select descripcion from CODIGOS_ERROR where codigo = @codigoError

exec registroUsuario 'Usuario11', 'abc123457'


/** 
	Login de un usuario 
						 **/
go
create procedure loginUsuario
	@usuario varchar(255), @clave varchar(255)
as
	--Verificamos si los datos introducidos son correctos
	if(select count(*) from USUARIO where @usuario = nombre and @clave = clave) = 1
		select descripcion from CODIGOS_ERROR where codigo = 0
	else
		begin
			if(select count(*) from USUARIO where @usuario = nombre) = 0 and (select count(*) from USUARIO where @clave = clave) = 0
				select descripcion from CODIGOS_ERROR where codigo = 5
			else
				select descripcion from CODIGOS_ERROR where codigo = 2
		end

exec loginUsuario 'Usuario7', 'abc123456'


/** 
	Ingreso de saldo 
					 **/
GO
create procedure ingresoSaldo 
	@usuarioId  int, @cantidad int
as
	--Declaramos variables
	declare @saldoUsuario decimal(10,3), @saldoInicial decimal(10,3), @saldoFinal decimal (10,3)
	--Extraemos el saldo
	set @saldoInicial = (Select saldo from USUARIO where @usuarioId = id_usuario)
		--Ejecución conjunta
		begin tran
			set @saldoFinal = @saldoInicial + @cantidad
			--Actualizamos el saldo del usuario
			update USUARIO set saldo = @saldoFinal where @usuarioId = id_usuario
			--Introducimos nueva transaccion
			Insert into TRANSACCION (id_tipo_transaccion, fecha_transaccion, id_usuario, monto, saldo_inicial, saldo_final)
			values (1, GETDATE(), @usuarioId, @cantidad, @saldoInicial, @saldoFinal)
		commit tran
	select nombre, saldo from USUARIO where id_usuario = @usuarioId

exec ingresoSaldo 7, 30


/** 
	Retiro de saldo 
					**/
GO
create procedure retireSaldo
	 @usuarioId  int, @cantidad int
as
	--Declaramos variables
	declare @saldoUsuario decimal(10,3), @saldoInicial decimal(10,3), @saldoFinal decimal (10,3), @codigoError int
	--Extraemos el saldo
	set @saldoInicial = (Select saldo from USUARIO where @usuarioId = id_usuario)
	--Verificamos que tenemos saldo para retirar
	if @saldoInicial >= @cantidad
		begin
			begin tran
				set @saldoFinal = @saldoInicial - @cantidad
				--Actualizamos el saldo del usuario
				update USUARIO set saldo = @saldoFinal where @usuarioId = id_usuario
				--Introducimos nueva transaccion
				Insert into TRANSACCION (id_tipo_transaccion, fecha_transaccion, id_usuario, monto, saldo_inicial, saldo_final)
				values (2, GETDATE(), @usuarioId, @cantidad, @saldoInicial, @saldoFinal)
				set @codigoError = 0
			commit tran
		end
	else
		set @codigoError = 3
	select descripcion from CODIGOS_ERROR where codigo = @codigoError

exec retireSaldo 5, 15

/** 
	Realizar apuesta 
					 **/
go
create procedure apostar
	@usuarioId int, @opcionId int, @cantidad int
as
	--Declaramos variables
	declare @saldoInicial decimal(10,3),@saldoFinal decimal(10,3), @codigoError int, @multiplicador decimal(10,3), @eventoId int, @fechaEvento datetime
	--Extraemos la fecha del evento a apostar.
	set @eventoId = (select id_evento from OPCION where @opcionId = id_opcion)
	set @fechaEvento = (select fecha from EVENTO where @eventoId = id_evento)
	--Verificamos si el evento aún no se realiza
	if @fechaEvento > GETDATE()
		begin
			set @saldoInicial = (select saldo from USUARIO where @usuarioId = id_usuario)
			set @multiplicador = (Select multiplicador from OPCION where id_opcion = @opcionId)
			--Verificamos si tenemos saldo suficiente
			if @saldoInicial >= @cantidad
				begin
					begin tran
						--Actualizamos el saldo del usuario
						set @saldoFinal = @saldoInicial - @cantidad
						update USUARIO set saldo = @saldoFinal where @usuarioId = id_usuario
						--Introducimos nueva transaccion
						Insert into TRANSACCION (id_tipo_transaccion, fecha_transaccion, id_usuario, monto, saldo_inicial, saldo_final)
						values (3, GETDATE(), @usuarioId, @cantidad, @saldoInicial, @saldoFinal)
						--Introducimos nueva apuesta realizada
						insert into APUESTA (id_usuario, id_opcion, fecha_apuesta, cantidad, multiplicador, id_transaccionP,id_transaccionC)
						values (@usuarioId, @opcionId, GETDATE(), @cantidad, @multiplicador, SCOPE_IDENTITY(), null)
					commit tran
					set @codigoError = 0
				end
				else
					set @codigoError = 3
		end
		else
			set @codigoError = 4
		select descripcion from CODIGOS_ERROR where codigo = @codigoError

exec apostar 7, 10, 5


/** 
	Muestra el saldo actual del usuario 
										**/
go 
create procedure mostrarSaldoUsuario
	@usuarioId int
as
	select saldo from USUARIO where id_usuario = @usuarioId

exec mostrarSaldoUsuario 1

/**
	Mostrar Tipos de eventos 
							 **/
GO
create procedure mostrarTiposEventos
as
	select * from TIPO_EVENTO

exec mostrarTiposEventos


/**
	Mostrar eventos disponibles
								**/
GO
create procedure mostrarEventos
as
	select * from EVENTO where fecha > GETDATE()

  

/**
	Mostrar opciones de eventos disponibles
											**/
go 
create procedure verOpcionesEvento
	@eventoId int
as
	declare @fechaEvento datetime
	set @fechaEvento = (select fecha from EVENTO where @eventoId = id_evento)
	if @fechaEvento > GETDATE()
		select id_opcion, fecha, nombre_evento, nombre_opcion, multiplicador 
		from EVENTO LEFT JOIN OPCION 
		on EVENTO.id_evento = OPCION.id_evento
		where @eventoId = OPCION.id_evento

exec verOpcionesEvento 4

drop procedure verOpcionesEvento
/**
	Ver apuestas del usuario
							 **/
go
create procedure verApuestas
	@usuarioId int
as
	--Consultamos y devolvemos datos de las tablas APUESTA y OPCION
	select fecha_apuesta, cantidad, apuesta.multiplicador, nombre_opcion, ganancia = (cantidad*apuesta.multiplicador), ganador 
	from APUESTA LEFT JOIN OPCION on apuesta.id_opcion = opcion.id_opcion
	where apuesta.id_usuario = @usuarioId
	order by fecha_apuesta

exec verApuestas 1

/**
	Ver transacciones del usuario
								  **/
go
create procedure verTransacciones
	@usuarioId int
as
	--Consultamos y devolvemos datos de las tablas TRANSACCION y TIPO_TRANSACCION
	SELECT fecha_transaccion, nombre as 'tipo_transaccion', monto, saldo_inicial, saldo_final 
	FROM TRANSACCION
	LEFT JOIN TIPO_TRANSACCION
	ON TRANSACCION.id_tipo_transaccion = TIPO_TRANSACCION.id_tipo_transaccion
	WHERE id_usuario = @usuarioId
	ORDER BY fecha_transaccion

exec verTransacciones 1
