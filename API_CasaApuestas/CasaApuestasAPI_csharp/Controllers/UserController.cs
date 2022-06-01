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
        public IEnumerable<string> acceso([FromForm] string username, [FromForm]string password)
        {
            DataTable login = conexionBaseDatos.ejecutarConsulta($"exec loginUsuario '{username}', '{password}'");

            return new string[] { login.Rows[0]["descripcion"].ToString() };
        }

        [HttpPost("registrar")]
        public IEnumerable<string> registro([FromForm] string username, [FromForm] string password)
        {
            DataTable registro = conexionBaseDatos.ejecutarConsulta($"exec registroUsuario '{username}', '{password}'");

            return new string[] { registro.Rows[0]["descripcion"].ToString() };
        }

    }
}
