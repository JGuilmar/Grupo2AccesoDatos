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
	if(select count(*) from usuario where nombre = @usuario) = 0
		insert into USUARIO(nombre, clave, saldo) values (@usuario, @clave, 0)
	else
		set @codigoError = 1
	select descripcion from CODIGOS_ERROR where codigo = @codigoError

exec registroUsuario 'Usuario7', 'abc123456'


/** 
	Login de un usuario 
						 **/

go
create procedure loginUsuario
	@usuario varchar(255), @clave varchar(255)
as
	if(select count(*) from USUARIO where @usuario = nombre and @clave = clave) = 1
		select descripcion from CODIGOS_ERROR where codigo = 0
	else
		select descripcion from CODIGOS_ERROR where codigo = 2

exec loginUsuario 'Usuario7', 'abc123456'


/** 
	Ingreso de saldo 
					 **/
GO
create procedure ingresoSaldo
	@cantidad int, 
	@usuarioId  int
as
	declare @saldoUsuario decimal(10,3), @saldoInicial decimal(10,3), @saldoFinal decimal (10,3)
	set @saldoInicial = (Select saldo from USUARIO where @usuarioId = id_usuario)
		begin tran
			set @saldoFinal = @saldoInicial + @cantidad
			update USUARIO set saldo = @saldoFinal where @usuarioId = id_usuario
			Insert into TRANSACCION (id_tipo_transaccion, fecha_transaccion, id_usuario, monto, saldo_inicial, saldo_final)
			values (1, GETDATE(), @usuarioId, @cantidad, @saldoInicial, @saldoFinal)
		commit tran
	select descripcion from CODIGOS_ERROR where codigo=0

exec ingresoSaldo 20,7


/** 
	Retiro de saldo 
					**/
GO
create procedure retireSaldo
	@cantidad int, @usuarioId  int
as
	declare @saldoUsuario decimal(10,3), @saldoInicial decimal(10,3), @saldoFinal decimal (10,3), @codigoError int
	set @saldoInicial = (Select saldo from USUARIO where @usuarioId = id_usuario)
	if @saldoInicial >= @cantidad
		begin
			begin tran
				set @saldoFinal = @saldoInicial - @cantidad
				update USUARIO set saldo = @saldoFinal where @usuarioId = id_usuario
				Insert into TRANSACCION (id_tipo_transaccion, fecha_transaccion, id_usuario, monto, saldo_inicial, saldo_final)
				values (2, GETDATE(), @usuarioId, @cantidad, @saldoInicial, @saldoFinal)
				set @codigoError = 0
			commit tran
		end
	else
		set @codigoError = 3
	select descripcion from CODIGOS_ERROR where codigo=@codigoError

exec retireSaldo 15,7

/** 
	Realizar apuesta 
					 **/
go
create procedure apostar
	@usuarioId int, @opcionId int, @cantidad int
as
	declare @saldoInicial decimal(10,3),@saldoFinal decimal(10,3), @codigoError int, @multiplicador decimal(10,3), @eventoId int, @fechaEvento datetime
	set @eventoId = (select id_evento from OPCION where @opcionId = id_opcion)
	set @fechaEvento = (select fecha from EVENTO where @eventoId = id_evento)
	if @fechaEvento > GETDATE()
		begin
			set @saldoInicial = (select saldo from USUARIO where @usuarioId = id_usuario)
			set @multiplicador = (Select multiplicador from OPCION where id_opcion = @opcionId)
			if @saldoInicial >= @cantidad
				begin
					begin tran
						set @saldoFinal = @saldoInicial - @cantidad
						update USUARIO set saldo = @saldoFinal where @usuarioId = id_usuario
						Insert into TRANSACCION (id_tipo_transaccion, fecha_transaccion, id_usuario, monto, saldo_inicial, saldo_final)
						values (3, GETDATE(), @usuarioId, @cantidad, @saldoInicial, @saldoFinal)
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

exec apostar 5, 10, 5


/** 
	Muestra el saldo actual del usuario 
										**/
go 
create procedure mostrarSaldoUsuario
	@usuarioId int
as
	if(select count(*) from USUARIO where @usuarioId = id_usuario ) = 1
		select saldo from USUARIO where id_usuario = @usuarioId
	else
		select descripcion from CODIGOS_ERROR where codigo = 5

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

exec mostrarEventos 

/**
	Ver apuestas del usuario
							 **/
go
create procedure verApuestas
	@usuarioId int
as
	select cantidad, apuesta.multiplicador, nombre_opcion, ganancia = (cantidad*apuesta.multiplicador), fecha_apuesta
	from APUESTA LEFT JOIN OPCION on apuesta.id_opcion = opcion.id_opcion
	where apuesta.id_usuario = @usuarioId
	order by fecha_apuesta

exec verApuestas 5


/**
	Ver transacciones del usuario
								  **/
go
create procedure verTransacciones
	@usuarioId int
as
	SELECT fecha_transaccion, nombre as 'tipo_transaccion', monto, saldo_inicial, saldo_final 
	FROM TRANSACCION
	LEFT JOIN TIPO_TRANSACCION
	ON TRANSACCION.id_tipo_transaccion = TIPO_TRANSACCION.id_tipo_transaccion
	WHERE id_usuario = @usuarioId
	ORDER BY fecha_transaccion

exec verTransacciones 1
