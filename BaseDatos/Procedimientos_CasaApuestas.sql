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

exec ingresoSaldo 4, 30


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

exec mostrarEventos

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






/**
 *
	PROCEDIMIENTOS PARA EL ADMINISTRADOR
									*
									**/

/** 
	Crear tipo evento
						**/
go
create procedure crearTipoEvento
	@nombreTipoEvento varchar(255), @descripcion varchar(255)
as
	begin tran
		insert into TIPO_EVENTO(nombre, descripcion) values (@nombreTipoEvento, @descripcion)
		select top(1) * from TIPO_EVENTO order by id_tipo_evento desc
	commit

exec crearTipoEvento 'Mundial Qatar 2022', 'Mundial de fútbol con 32 selecciones'


/**
	Crear evento
				 **/
go
create procedure crearEvento
	@idTipoEvento int, @nombreEvento varchar(255), @fechaEvento datetime
as
	begin tran
		Insert into EVENTO(nombre_evento, fecha, id_tipo_evento) values (@nombreEvento, @fechaEvento, @idTipoEvento)
		select top(1) * from EVENTO order by id_evento desc
	commit

exec crearEvento 6, 'Qatar vs Ecuador', '2022-11-21T17:00:00'


/**
	Crear opcion de evento
							**/
go 
create procedure crearOpcion
	@idEvento int, @nombreOpcion varchar(255), @multiplicador decimal(10,2)
as
	begin tran
		insert into OPCION(id_evento, nombre_opcion, multiplicador) values (@idEvento, @nombreOpcion, @multiplicador)
		select top(1) * from OPCION order by id_opcion desc
	commit

exec crearOpcion 9,'Ecuador', 1.5



/** 
	Cerrar opcion 
					**/
go
create procedure cerrarOpcion
	@opcionId int, @ganador bit
as
	declare @usuarioId int, @saldoInicial decimal(10,3), @saldoFinal decimal(10,3), @transaccionId int, @apuestaId int, @cantidad int, @eventoId int
	update opcion set ganador = @ganador where id_opcion = @opcionId
	if @ganador = 1
	begin
	--Creamos cursor para que al momento de elegir el ganador se hagas las pagas respectivas de las apuestas ganadas
		declare cobrar_Apuesta cursor for select id_apuesta, cantidad * multiplicador, id_usuario from apuesta where id_opcion = @opcionId
		open cobrar_Apuesta
			fetch next from cobrar_Apuesta into @apuestaId, @cantidad, @usuarioId
			while @@FETCH_STATUS = 0
			begin
				begin tran
					set @saldoInicial = (select saldo from USUARIO where @usuarioId = id_usuario)
					set @saldoFinal = @saldoInicial + @cantidad
					Insert into TRANSACCION (id_tipo_transaccion, fecha_transaccion, id_usuario, monto, saldo_inicial, saldo_final)
					values (4, GETDATE(), @usuarioId, @cantidad, @saldoInicial, @saldoFinal)
					update APUESTA set id_transaccionC = SCOPE_IDENTITY() where id_apuesta = @apuestaId
					update USUARIO set saldo = @saldoFinal where id_usuario = @usuarioId
				commit tran
				fetch next from cobrar_Apuesta into @apuestaId, @cantidad, @usuarioId
			end
		close cobrar_Apuesta
		deallocate cobrar_Apuesta
		--set @eventoId = (select id_evento from OPCION where @opcionId = id_opcion)
		--update OPCION set ganador = 0 where @eventoId = id_evento and @opcionId <> id_opcion
		--Select * from OPCION where @eventoId = id_evento
		select descripcion from CODIGOS_ERROR where codigo = 0
	end

exec cerrarOpcion 4,1


/**
	Actualizar multiplicador opcion
					**/
go 
create procedure actualizarMultiplicador
	@eventoId int, @nombreOpcion varchar(255), @multiplicadorOpcion decimal(10,2)
as 
	declare @fechaEvento datetime
	set @fechaEvento = (select fecha from EVENTO where @eventoId = id_evento)
	if @fechaEvento > GETDATE()
		begin
			update OPCION set multiplicador = @multiplicadorOpcion where @eventoId = id_evento and @nombreOpcion =nombre_opcion
			Select descripcion from CODIGOS_ERROR where codigo = 0
		end
	else
		Select descripcion from CODIGOS_ERROR where codigo = 4

exec actualizarMultiplicador 3, 'Nadal', 1.40



/** 
	Listando procedimientos almacenados creados 
												**/
SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE ROUTINE_TYPE = 'PROCEDURE'
   ORDER BY ROUTINE_NAME