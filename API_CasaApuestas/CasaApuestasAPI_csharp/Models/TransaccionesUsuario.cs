namespace CasaApuestasAPI_csharp.Models
{
    public class TransaccionesUsuario
    {
        public string fecha_transaccion { get; set; }
        public string tipo_transaccion { get; set; }
        public decimal monto { get; set; }
        public decimal saldo_inicial { get; set; }
        public decimal saldo_final { get; set; }
    }
}
