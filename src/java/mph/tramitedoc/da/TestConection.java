/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mph.tramitedoc.da;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import mph.tramitedoc.system.ParametrosSystem;

/**
 *
 * @author Erik
 */
public class TestConection extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public TestConection(String cadenaConexion, String DriverConnection, String user, String password) {
        this.cadenaConexion = cadenaConexion;
        this.DriverConnection = DriverConnection;
        this.user = user;
        this.password = password;
    }

    public TestConection() {
        cadenaConexion = ParametrosSystem.getUrlPostgres();
        DriverConnection = ParametrosSystem.getDriverPostgres();
        user = ParametrosSystem.getUsuarioPostgres();
        password = ParametrosSystem.getPasswordPostgres();
    }

    public Connection testConection() throws SQLException {
        Connection cn = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
        } catch (Exception ex) {
            cn = null;
            ex.printStackTrace();
        }
        return cn;
    }
}
