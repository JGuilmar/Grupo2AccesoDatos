using Microsoft.AspNetCore.Mvc;
using System.Data;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace CasaApuestasAPI_csharp.Controllers
{
    [Route("api/usuarioCasaApuestas")]
    [ApiController]
    public class UserController : ControllerBase
    {
        BaseDatos conexionBaseDatos = new BaseDatos("localhost", "BetHouse", "bayonaJose", "abc12345..");

        [HttpPost("acceder")]
        public IEnumerable<string> acceso([FromForm] string usuario, [FromForm]string contraseña)
        {
            DataTable login = conexionBaseDatos.ejecutarConsulta($"exec loginUsuario '{usuario}', '{contraseña}'");

            return new string[] { login.Rows[0]["descripcion"].ToString() };
        }

        [HttpPost("registrar")]
        public IEnumerable<string> registro([FromForm] string usuario, [FromForm] string contraseña)
        {
            DataTable registro = conexionBaseDatos.ejecutarConsulta($"exec registroUsuario '{usuario}', '{contraseña}'");

            return new string[] { registro.Rows[0]["descripcion"].ToString() };
        }

        [HttpPost("ingresarDinero")]
        public IEnumerable<string> ingresarDinero([FromForm] int usuarioId, [FromForm] int monto)
        {
            DataTable ingreso = conexionBaseDatos.ejecutarConsulta($"exec ingresoSaldo '{usuarioId}', '{monto}'");

            return new string[] { $"Usuario: {ingreso.Rows[0]["nombre"].ToString()}", $"Saldo  : {ingreso.Rows[0]["saldo"].ToString()}" };
        }

        [HttpPost("retirarDinero")]
        public IEnumerable<string> retirarDinero([FromForm] int usuarioId, [FromForm] int monto)
        {
            DataTable retiro = conexionBaseDatos.ejecutarConsulta($"exec retireSaldo '{usuarioId}', '{monto}'");

            return new string[] { retiro.Rows[0]["descripcion"].ToString() };
        }




    }
}
