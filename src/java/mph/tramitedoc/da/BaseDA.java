package mph.tramitedoc.da;

import mph.tramitedoc.system.ParametrosSystem;

public class BaseDA {

    private String connectionString;
    private String driverConnection;
    private String user;
    private String password;

    public BaseDA() {

        connectionString = ParametrosSystem.getUrlPostgres();
        driverConnection = ParametrosSystem.getDriverPostgres();
        user = ParametrosSystem.getUsuarioPostgres();
        password = ParametrosSystem.getPasswordPostgres();

    }

    public String getConnectionString() {
        return connectionString;
    }

    public void setConnectionString(String connectionString) {
        this.connectionString = connectionString;
    }

    public String getDriverConnection() {
        return driverConnection;
    }

    public void setDriverConnection(String driverConnection) {
        this.driverConnection = driverConnection;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
