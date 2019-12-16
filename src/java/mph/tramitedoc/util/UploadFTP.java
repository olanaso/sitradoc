package mph.tramitedoc.util;

import mph.tramitedoc.system.ParametrosSystem;
import mph.tramitedoc.util.*;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.security.MessageDigest;
import java.util.StringTokenizer;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.springframework.web.multipart.MultipartFile;

/**
 *
 * @author Erik
 */
public class UploadFTP {

    public void uploadFTP(MultipartFile mpf, String namefile) throws UnknownHostException, IOException {
        try {

            FTPClient ftpClient = new FTPClient();
            ftpClient.connect(ParametrosSystem.getIp_adrres_ftp(), ParametrosSystem.getPort_ftp());
            ftpClient.login(ParametrosSystem.getUser_ftp(), ParametrosSystem.getPassword_ftp());

            //Verificar conexión con el servidor.
            int reply = ftpClient.getReplyCode();

            System.out.println("Respuesta recibida de conexión FTP:" + reply);

            if (FTPReply.isPositiveCompletion(reply)) {
                System.out.println("Conectado Satisfactoriamente");
            } else {
                System.out.println("Imposible conectarse al servidor");
            }

            //Verificar si se cambia de direcotirio de trabajo
            ftpClient.changeWorkingDirectory("/"+ParametrosSystem.getFolder_save_ftp());//Cambiar directorio de trabajo
            System.out.println("Se cambió satisfactoriamente el directorio");

            //Activar que se envie cualquier tipo de archivo
            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);

//            BufferedInputStream buffIn = null;
//            buffIn = new BufferedInputStream(new FileInputStream(""));//Ruta del archivo para enviar
//            ftpClient.enterLocalPassiveMode();
            InputStream is = new ByteArrayInputStream(mpf.getBytes());
            ftpClient.storeFile(namefile, is);//Ruta completa de alojamiento en el FTP

            //buffIn.close(); //Cerrar envio de arcivos al FTP
            ftpClient.logout(); //Cerrar sesión
            ftpClient.disconnect();//Desconectarse del servidor
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Algo malo sucedió");
        }
    }
    
    public boolean deleteFTP( String namefile) throws UnknownHostException, IOException {
        boolean result;
        try {

            FTPClient ftpClient = new FTPClient();
            ftpClient.connect(ParametrosSystem.getIp_adrres_ftp(), ParametrosSystem.getPort_ftp());
            ftpClient.login(ParametrosSystem.getUser_ftp(), ParametrosSystem.getPassword_ftp());

            //Verificar conexión con el servidor.
            int reply = ftpClient.getReplyCode();

            System.out.println("Respuesta recibida de conexión FTP:" + reply);

            if (FTPReply.isPositiveCompletion(reply)) {
                System.out.println("Conectado Satisfactoriamente");
            } else {
                System.out.println("Imposible conectarse al servidor");
            }

            //Verificar si se cambia de direcotirio de trabajo
            ftpClient.changeWorkingDirectory("/"+ParametrosSystem.getFolder_save_ftp());//Cambiar directorio de trabajo
            System.out.println("Se cambió satisfactoriamente el directorio");

            //Activar que se envie cualquier tipo de archivo
            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);

//            BufferedInputStream buffIn = null;
//            buffIn = new BufferedInputStream(new FileInputStream(""));//Ruta del archivo para enviar
//            ftpClient.enterLocalPassiveMode();
           // InputStream is = new ByteArrayInputStream(mpf.getBytes());
            result=ftpClient.deleteFile(namefile);//Ruta completa de alojamiento en el FTP

            //buffIn.close(); //Cerrar envio de arcivos al FTP
            ftpClient.logout(); //Cerrar sesión
            ftpClient.disconnect();//Desconectarse del servidor
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Algo malo sucedió");
            result=false;
        }
        return result;
    }

    public boolean testuploadFTP(String ip_address,int port,String user, String password) throws UnknownHostException, IOException {
        boolean result = false;
        try {

            FTPClient ftpClient = new FTPClient();
            ftpClient.connect(ip_address, port);
            ftpClient.login(user, password);

            int reply = ftpClient.getReplyCode();
            System.out.println("Respuesta recibida de conexión FTP:" + reply);
            result = FTPReply.isPositiveCompletion(reply);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Algo malo sucedió");
        }
        return result;
    }

}