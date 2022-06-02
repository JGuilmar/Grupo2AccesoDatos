namespace CasaApuestasAPI_csharp.Models
{
    public class ApuestasUsuario
    {
        public string fecha_apuesta { get; set; }
        public decimal cantidad { get; set; }
        public decimal multiplicador { get; set; }
        public string nombre_opcion { get; set; }
        public decimal ganancia { get; set; }
    }
}
