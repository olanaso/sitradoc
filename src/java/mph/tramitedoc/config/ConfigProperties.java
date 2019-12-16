package mph.tramitedoc.config;

import mph.tramitedoc.security.Cripto;
import mph.tramitedoc.system.ParametrosSystem;
import mph.tramitedoc.util.Parameter;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ConfigProperties {

    public int getProperties(String path) throws Exception {
        try {
            //se crea una instancia a la clase Properties
            File file = new File(path + "\\config\\" + Parameter.config_properties);

            if (file.exists()) {

                Properties propiedades = new Properties();

                InputStream file_properties = new FileInputStream(file);
                propiedades.load(file_properties);
                ParametrosSystem.setUrlPostgres(Cripto.Desencriptar(propiedades.getProperty("connectionString")));
                ParametrosSystem.setDriverPostgres(Cripto.Desencriptar(propiedades.getProperty("driverConnection")));
                ParametrosSystem.setUsuarioPostgres(Cripto.Desencriptar(propiedades.getProperty("user")));
                ParametrosSystem.setPasswordPostgres(Cripto.Desencriptar(propiedades.getProperty("dbpassword")));
                ParametrosSystem.setNickSistema(Cripto.Desencriptar(propiedades.getProperty("sistema")));

                //si el archivo de propiedades NO esta vacio retornan las propiedes leidas
                if (!propiedades.isEmpty()) {
                    return 1; //el archivo no posee configuraciones
                } else {//sino  retornara NULL
                    return -1; // La configuracion fue cargada correctamente
                }

            } else {
                return -2; // El archivo no existe 
            }

        } catch (IOException ex) {
            return -3; //ocurrio un error desconocido
        }
    }

    public int getFTPProperties(String path) throws Exception {
        try {
            //se crea una instancia a la clase Properties

            File ftp = new File(path + "\\config\\" + Parameter.ftp_properties);

            if (ftp.exists()) {

                /*Parametros de FTP*/
                Properties ftp_propiedades = new Properties();
                InputStream ftp_properties = new FileInputStream(ftp);
                ftp_propiedades.load(ftp_properties);
                System.out.println("ftp:" + ftp_propiedades.getProperty("ftp_port"));

                ParametrosSystem.setIp_adrres_ftp(Cripto.Desencriptar(ftp_propiedades.getProperty("ftp_ip_address")));
                ParametrosSystem.setUrl_access_ftp(Cripto.Desencriptar(ftp_propiedades.getProperty("ftp_url_access")));
                ParametrosSystem.setFolder_save_ftp(Cripto.Desencriptar(ftp_propiedades.getProperty("ftp_folder_save")));
                if (ftp_propiedades.getProperty("ftp_port") == null) {
                    ParametrosSystem.setPort_ftp(0);
                } else {
                    ParametrosSystem.setPort_ftp(Integer.parseInt(Cripto.Desencriptar(ftp_propiedades.getProperty("ftp_port"))));
                }

                ParametrosSystem.setUser_ftp(Cripto.Desencriptar(ftp_propiedades.getProperty("ftp_user")));
                ParametrosSystem.setPassword_ftp(Cripto.Desencriptar(ftp_propiedades.getProperty("ftp_password")));

                //si el archivo de propiedades NO esta vacio retornan las propiedes leidas
                if (!ftp_propiedades.isEmpty()) {
                    return 1; //el archivo no posee configuraciones
                } else {//sino  retornara NULL
                    return -1; // La configuracion fue cargada correctamente
                }

            } else {
                return -2; // El archivo no existe 
            }

        } catch (IOException ex) {
            return -3; //ocurrio un error desconocido
        }
    }
}