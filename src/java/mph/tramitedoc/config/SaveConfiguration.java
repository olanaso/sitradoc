package mph.tramitedoc.config;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Properties;
import mph.tramitedoc.be.ParametrosSystemBE;
import mph.tramitedoc.security.Cripto;
import mph.tramitedoc.util.Parameter;

/**
 *
 * @author ERIK-PC
 */
public class SaveConfiguration {

    public boolean save(ParametrosSystemBE oSystemBE, String path) {
        Properties prop = new Properties();
        OutputStream output = null;
        boolean retorno = false;
        try {

            File configFile = new File(path + "\\config\\" + Parameter.config_properties);
            File directory = new File(path + "\\config\\");

            if (!configFile.exists()) {
                if (directory.mkdir()) {
                    configFile.createNewFile();
                } else {
                    System.out.println("Failed to create directory!");
                }
            }
            // FileOutputStream oFile = new FileOutputStream(yourFile, false);

            output = new FileOutputStream(path + "\\config\\" + Parameter.config_properties);
            // set the properties value
            prop.setProperty("connectionString", Cripto.Encriptar(oSystemBE.getUrlPostgres()));
            prop.setProperty("driverConnection", Cripto.Encriptar(oSystemBE.getDriverPostgres()));
            prop.setProperty("dbpassword", Cripto.Encriptar(oSystemBE.getPasswordPostgres()));
            prop.setProperty("user", Cripto.Encriptar(oSystemBE.getUsuarioPostgres()));
            prop.setProperty("sistema", Cripto.Encriptar(oSystemBE.getNickSistema()));

            // save properties to project root folder
            prop.store(output, null);
            retorno = true;

        } catch (IOException io) {
            io.printStackTrace();
            retorno = false;
        } finally {
            if (output != null) {
                try {
                    output.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
        return retorno;
    }

    public boolean saveFTP(ParametrosSystemBE oSystemBE, String path) {
        Properties prop = new Properties();
        OutputStream output = null;
        boolean retorno = false;
        
        try {

            File configFile = new File(path + "\\config\\" + Parameter.ftp_properties);
            File directory = new File(path + "\\config\\");

            if (!configFile.exists()) {
                if (directory.mkdir()) {
                    configFile.createNewFile();
                } else {
                    System.out.println("Failed to create directory!");
                }
            }
            // FileOutputStream oFile = new FileOutputStream(yourFile, false);

            output = new FileOutputStream(path + "\\config\\" + Parameter.ftp_properties);
            // set the properties value
            prop.setProperty("ftp_ip_address", Cripto.Encriptar(oSystemBE.getFtp_ip_address()));
            prop.setProperty("ftp_url_access", Cripto.Encriptar(oSystemBE.getFtp_url_access()));
            prop.setProperty("ftp_folder_save", Cripto.Encriptar(oSystemBE.getFtp_folder_save()));
            prop.setProperty("ftp_user", Cripto.Encriptar(oSystemBE.getFtp_user()));
            prop.setProperty("ftp_password", Cripto.Encriptar(oSystemBE.getFtp_password()));
            prop.setProperty("ftp_port", Cripto.Encriptar(String.valueOf(oSystemBE.getFtp_port())));

            // save properties to project root folder
            prop.store(output, null);
            retorno = true;

        } catch (IOException io) {
            io.printStackTrace();
            retorno = false;
        } finally {
            if (output != null) {
                try {
                    output.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
        return retorno;
    }
}