namespace CasaApuestasAPI_csharp.Models
{
    public class OpcionesEvento
    {
        public int id_opcion { get; set; }
        public string fecha { get; set; }
        public string nombre_evento { get; set; }
        public string nombre_opcion { get; set; }
        public decimal multiplicador { get; set; }
    }
}
