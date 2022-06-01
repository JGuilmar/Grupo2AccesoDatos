using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DT = System.Data;
using QC = Microsoft.Data.SqlClient;


public class BaseDatos
{
    private QC.SqlConnection connection;

    public BaseDatos(string server, string bbdd, string user, string pass)
    {
        this.connection = new QC.SqlConnection($@"Server = {server}; 
                                                Database = {bbdd}; 
                                                User ID = {user}; 
                                                Password={pass}; 
                                                Encrypt=False; 
                                                TrustServerCertificate=True; 
                                                Connection Timeout = 20;");
    }

    public System.Data.DataTable ejecutarConsulta(string consulta)
    {
        using (var command = new QC.SqlCommand())
        {
            command.Connection = this.connection;
            command.CommandType = DT.CommandType.Text;
            command.CommandText = consulta;

            command.Connection.Open();
            QC.SqlDataReader reader = command.ExecuteReader();
            System.Data.DataTable dt = new DT.DataTable();

            dt.Load(reader);
            command.Connection.Close();
            return dt;

        }
    }
}
