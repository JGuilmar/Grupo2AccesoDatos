using Microsoft.AspNetCore.Mvc;
using System.Data;
using CasaApuestasAPI_csharp.Models;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CasaApuestasAPI_csharp.Controllers
{
    [Route("api/usuarioCasaApuestas")]
    [ApiController]
    public class UserController : ControllerBase
    {
        BaseDatos conexionBaseDatos = new BaseDatos("localhost", "BetHouse", "bayonaJose", "abc12345..");

        //Acceso de usuario
        [HttpPost("acceder")]
        public IEnumerable<string> acceso([FromForm] string usuario, [FromForm]string contraseña)
        {
            DataTable dtLogin = conexionBaseDatos.ejecutarConsulta($"exec loginUsuario '{usuario}', '{contraseña}'");

            return new string[] { dtLogin.Rows[0]["descripcion"].ToString() };
        }

        //Registro de usuario
        [HttpPost("registrar")]
        public IEnumerable<string> registro([FromForm] string usuario, [FromForm] string contraseña)
        {
            DataTable dtRegistro = conexionBaseDatos.ejecutarConsulta($"exec registroUsuario '{usuario}', '{contraseña}'");

            return new string[] { dtRegistro.Rows[0]["descripcion"].ToString() };
        }

        //Ingreso de dinero del usuario
        [HttpPost("ingresarDinero")]
        public IEnumerable<string> ingresarDinero([FromForm] int usuarioId, [FromForm] int monto)
        {
            DataTable dtIngreso = conexionBaseDatos.ejecutarConsulta($"exec ingresoSaldo {usuarioId}, {monto}");

            return new string[] { $"Usuario: {dtIngreso.Rows[0]["nombre"].ToString()}", 
                                  $"Saldo  : {dtIngreso.Rows[0]["saldo"].ToString()}" };
        }

        //Retiro de dinero del usuario
        [HttpPost("retirarDinero")]
        public IEnumerable<string> retirarDinero([FromForm] int usuarioId, [FromForm] int monto)
        {
            DataTable dtRetiro = conexionBaseDatos.ejecutarConsulta($"exec retireSaldo {usuarioId}, {monto}");

            return new string[] { dtRetiro.Rows[0]["saldo"].ToString() };
        }

        //Ver saldo según el id del usuario
        [HttpGet("verSaldo/{usuarioId}")]
        public IEnumerable<string> verSaldo(int usuarioId)
        {
            DataTable dtMostrarSaldo = conexionBaseDatos.ejecutarConsulta($"exec mostrarSaldoUsuario {usuarioId}");

            return new string[] { dtMostrarSaldo.Rows[0]["saldo"].ToString() };

        }

        //Ver los tipos de eventos 
        [HttpGet("verTiposEventos")]
        public IEnumerable<TiposEventos> verTiposEventos()
        {
            List<TiposEventos> listaTiposEventos = new List<TiposEventos>();
            DataTable dtTiposEventos = conexionBaseDatos.ejecutarConsulta($"exec mostrarTiposEventos");

            foreach (DataRow rowTiposEventos in dtTiposEventos.Rows)
            {
                TiposEventos tiposEventos = new TiposEventos();

                tiposEventos.id_tipo_evento = int.Parse(rowTiposEventos[0].ToString());
                tiposEventos.nombre = rowTiposEventos[1].ToString();
                tiposEventos.descripcion = rowTiposEventos[2].ToString();

                listaTiposEventos.Add(tiposEventos);

            }
            return listaTiposEventos;
        }

        //Ver los eventos disponibles para apostar
        [HttpGet("verEventosDisponibles")]
        public IEnumerable<EventosDisponibles> verEventosDisponibles()
        {
            List<EventosDisponibles> listaEventosDisponible = new List<EventosDisponibles>();
            DataTable dtEventosDisponibles = conexionBaseDatos.ejecutarConsulta($"exec mostrarEventos");

            foreach(DataRow rowEventosDisponible in dtEventosDisponibles.Rows)
            {
                EventosDisponibles eventosDisponibles = new EventosDisponibles();

                eventosDisponibles.id_evento = int.Parse(rowEventosDisponible[0].ToString());
                eventosDisponibles.nombre = rowEventosDisponible[1].ToString();
                eventosDisponibles.fecha = rowEventosDisponible[2].ToString();

                listaEventosDisponible.Add(eventosDisponibles);
            }
            return listaEventosDisponible;
        }

        //Ver las opciones segun el id del evento disponible
        [HttpGet("verOpcionesEvento/{eventoId}")]
        public IEnumerable<OpcionesEvento> verOpcionesEvento(int eventoId)
        {
            List<OpcionesEvento> listaOpcionesEvento = new List<OpcionesEvento>();
            DataTable dtOpcionesEvento = conexionBaseDatos.ejecutarConsulta($"exec verOpcionesEvento {eventoId}");

            foreach(DataRow rowOpcionesEvento in dtOpcionesEvento.Rows)
            {
                OpcionesEvento opcionesEvento = new OpcionesEvento();

                opcionesEvento.id_opcion = int.Parse(rowOpcionesEvento[0].ToString());
                opcionesEvento.fecha = rowOpcionesEvento[1].ToString();
                opcionesEvento.nombre_evento = rowOpcionesEvento[2].ToString();
                opcionesEvento.nombre_opcion = rowOpcionesEvento[3].ToString();
                opcionesEvento.multiplicador = decimal.Parse(rowOpcionesEvento[4].ToString());

                listaOpcionesEvento.Add(opcionesEvento);
            }

            return listaOpcionesEvento;
        }

        //Realizar apuesta
        [HttpPost("apostar")]
        public IEnumerable<string> apostar([FromForm] int usuarioId, [FromForm] int opcionId, [FromForm] int cantidad)
        {
            DataTable dtApostar = conexionBaseDatos.ejecutarConsulta($"exec apostar {usuarioId}, {opcionId}, {cantidad}");

            return new string[] { dtApostar.Rows[0]["descripcion"].ToString() };
        }


        //Ver historial de apuestas segun el id del usuario
        [HttpGet("verApuestas/{usuarioId}")]
        public IEnumerable<ApuestasUsuario> verApuestasUsuario(int usuarioId)
        {
            List<ApuestasUsuario> listaApuestasUsuario = new List<ApuestasUsuario>();
            DataTable dtApuestasUsuario = conexionBaseDatos.ejecutarConsulta($"exec verApuestas {usuarioId}");

            foreach(DataRow rowApuestasUsuario in dtApuestasUsuario.Rows)
            {
                ApuestasUsuario apuestasUsuario = new ApuestasUsuario();

                apuestasUsuario.fecha_apuesta = rowApuestasUsuario[0].ToString();
                apuestasUsuario.cantidad = decimal.Parse(rowApuestasUsuario[1].ToString());
                apuestasUsuario.multiplicador = decimal.Parse(rowApuestasUsuario[2].ToString());
                apuestasUsuario.nombre_opcion = rowApuestasUsuario[3].ToString();
                apuestasUsuario.ganancia = decimal.Parse(rowApuestasUsuario[4].ToString());

                listaApuestasUsuario.Add(apuestasUsuario);
            }

            return listaApuestasUsuario;
        }

        //Ver los movimientos segun el id del usuario
        [HttpGet("verTransacciones/{usuarioId}")]
        public IEnumerable<TransaccionesUsuario> verTransaccionesUsuario(int usuarioId)
        {
            List<TransaccionesUsuario> listaTransaccionesUsuario = new List<TransaccionesUsuario>();
            DataTable dtTransaccionesUsuario = conexionBaseDatos.ejecutarConsulta($"exec verTransacciones {usuarioId}");

            foreach (DataRow rowTransaccionesUsuario in dtTransaccionesUsuario.Rows)
            {
                TransaccionesUsuario transaccionesUsuario = new TransaccionesUsuario();

                transaccionesUsuario.fecha_transaccion = rowTransaccionesUsuario[0].ToString();
                transaccionesUsuario.tipo_transaccion = rowTransaccionesUsuario[1].ToString();
                transaccionesUsuario.monto = decimal.Parse(rowTransaccionesUsuario[2].ToString());
                transaccionesUsuario.saldo_inicial = decimal.Parse(rowTransaccionesUsuario[3].ToString());
                transaccionesUsuario.saldo_final = decimal.Parse(rowTransaccionesUsuario[4].ToString());

                listaTransaccionesUsuario.Add(transaccionesUsuario);
            }

            return listaTransaccionesUsuario;
        }

    }
}
