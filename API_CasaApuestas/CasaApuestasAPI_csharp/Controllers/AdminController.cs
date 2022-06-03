using Microsoft.AspNetCore.Mvc;
using System.Data;
using CasaApuestasAPI_csharp.Models;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CasaApuestasAPI_csharp.Controllers
{
    [Route("api/administradorCasaApuestas")]
    [ApiController]
    public class AdminController : ControllerBase
    {
        BaseDatos conexionBaseDatos = new BaseDatos("localhost", "BetHouse", "bayonaJose", "abc12345..");

        //Crear un tipo de evento
        [HttpPost("crearTipoEvento")]
        public IEnumerable<string> crearTipoEvento([FromForm] string nombre, [FromForm] string descripcion)
        {
            DataTable dtCrearTipoEvento = conexionBaseDatos.ejecutarConsulta($"exec crearTipoEvento '{nombre}', '{descripcion}'");

            return new string[] { $"IdTipoEvento: {dtCrearTipoEvento.Rows[0]["id_tipo_evento"].ToString()}",
                                  $"Nombre: {dtCrearTipoEvento.Rows[0]["nombre"].ToString()}", 
                                  $"Descripcion : {dtCrearTipoEvento.Rows[0]["descripcion"].ToString()}" };
        }

        //Crear un evento para un tipo de evento
        [HttpPost("crearEvento")]
        public IEnumerable<string> crearEvento([FromForm] int tipoEventoId, [FromForm] string nombreEvento, [FromForm] string fechaEvento)
        {
            DataTable dtCrearEvento = conexionBaseDatos.ejecutarConsulta($"exec crearEvento {tipoEventoId}, '{nombreEvento}', '{fechaEvento}'");

            return new string[] { $"IdEvento: {dtCrearEvento.Rows[0]["id_evento"].ToString()}", 
                                  $"Nombre: {dtCrearEvento.Rows[0]["nombre_evento"].ToString()}", 
                                  $"Fecha : {dtCrearEvento.Rows[0]["fecha"].ToString()}" };
        }

        //Crear una opcion para un evento
        [HttpPost("crearOpcionEvento")]
        public IEnumerable<string> crearOpcionEvento([FromForm] int eventoId, [FromForm] string nombreOpcion, [FromForm] float multiplicador)
        {
            DataTable dtCrearOpcionEvento = conexionBaseDatos.ejecutarConsulta($"exec crearOpcion {eventoId}, '{nombreOpcion}', {multiplicador}");

            return new string[] { $"IdOpcion: {dtCrearOpcionEvento.Rows[0]["id_opcion"].ToString()}", 
                                  $"Nombre: {dtCrearOpcionEvento.Rows[0]["nombre_opcion"].ToString()}", 
                                  $"Multiplicador : {dtCrearOpcionEvento.Rows[0]["multiplicador"].ToString()}" };
        }

        //Cierra un evento dando ganador a una opcion y a las demás como perdedoras, además de pagar a los usuarios ganadores.
        [HttpPost("cerrarOpcion")]
        public IEnumerable<string> cerrarOpcion([FromForm] int eventoId, [FromForm] bool ganador)
        {
            DataTable dtCerrarOpcion = conexionBaseDatos.ejecutarConsulta($"exec cerrarOpcion {eventoId}, {ganador}");

            return new string[] { dtCerrarOpcion.Rows[0]["descripcion"].ToString() };
        }


        [HttpPost("actualizarMultiplicador")]
        public IEnumerable<string> actualizaMultiplicador([FromForm] int eventoId, [FromForm] string nombreOpcion, [FromForm] float multiplicador)
        {
            DataTable dtActualizaMultiplicador = conexionBaseDatos.ejecutarConsulta($"exec actualizarMultiplicador {eventoId}, '{nombreOpcion}', {multiplicador}");

            return new string[] { dtActualizaMultiplicador.Rows[0]["descripcion"].ToString() };
        }
    
    }
}
