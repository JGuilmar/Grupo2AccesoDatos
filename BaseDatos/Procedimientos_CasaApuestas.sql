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

exec registroUsuario 'Usuario7', 'abc123456'


/** 
	Login de un usuario 
						 **/

go
create procedure loginUsuario
	@usuario varchar(255), @clave varchar(255)
as
	--Verificamos si los datos introducidos son correctos.
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
	select descripcion from CODIGOS_ERROR where codigo=0

exec ingresoSaldo 20,7


/** 
	Retiro de saldo 
					**/
GO
create procedure retireSaldo
	@cantidad int, @usuarioId  int
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
	select descripcion from CODIGOS_ERROR where codigo=@codigoError

exec retireSaldo 15,7

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
	--Consultamos y devolvemos datos de las tablas APUESTA y OPCION
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
	--Consultamos y devolvemos datos de las tablas TRANSACCION y TIPO_TRANSACCION
	SELECT fecha_transaccion, nombre as 'tipo_transaccion', monto, saldo_inicial, saldo_final 
	FROM TRANSACCION
	LEFT JOIN TIPO_TRANSACCION
	ON TRANSACCION.id_tipo_transaccion = TIPO_TRANSACCION.id_tipo_transaccion
	WHERE id_usuario = @usuarioId
	ORDER BY fecha_transaccion

exec verTransacciones 1
