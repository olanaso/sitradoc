package mph.tramitedoc.util;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import mph.tramitedoc.da.BaseDA;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import org.apache.tomcat.util.codec.binary.Base64;
import org.apache.tomcat.util.codec.binary.StringUtils;

public class ReportManager extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public ReportManager() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public JasperPrint generarReporte(JasperReport jasperReport, Map parametros) throws SQLException {
        Connection cn = null;
        try {
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            JasperPrint pri = JasperFillManager.fillReport(jasperReport, parametros, cn);
            return pri;
        } catch (JRException ex) {
            Logger.getLogger(ReportManager.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            cn.close();
        }
    }

    public String generarReportepdf(JasperReport jasperReport, Map parametros) throws SQLException {
        Connection cn = null;
        String reportb64 = "";
        try {
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            byte[] pri = JasperRunManager.runReportToPdf(jasperReport, parametros, cn);
            StringBuilder sb = new StringBuilder();
            sb.append("data:application/pdf;base64,");
            sb.append(StringUtils.newStringUtf8(Base64.encodeBase64(pri, false)));
            reportb64 = sb.toString();
        } catch (JRException ex) {
            Logger.getLogger(ReportManager.class.getName()).log(Level.SEVERE, null, ex);
            reportb64 = ex.getMessage();
        } finally {
            cn.close();
        }
        return reportb64;
    }

    public String generarReportexls(JasperReport jasperReport, Map parametros) throws SQLException, FileNotFoundException, IOException {
        Connection cn = null;
        try {
            String outFileName = "excel.xls";
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            JasperPrint print = JasperFillManager.fillReport(jasperReport, parametros, cn);
            JRExporter exporter = new JRXlsExporter();
            exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, outFileName);
            exporter.setParameter(JRExporterParameter.JASPER_PRINT, print);
            exporter.exportReport();
            File archivo = new File(outFileName);
            FileInputStream fis = new FileInputStream(outFileName);
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            byte[] buf = new byte[1024];
            try {
                for (int readNum; (readNum = fis.read(buf)) != -1;) {
                    bos.write(buf, 0, readNum);
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
            StringBuilder sb = new StringBuilder();
            sb.append("data:application/vnd.ms-excel;base64,");
            sb.append(StringUtils.newStringUtf8(Base64.encodeBase64(bos.toByteArray(), false)));
            return sb.toString();

        } catch (JRException ex) {
            Logger.getLogger(ReportManager.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            cn.close();
        }
    }

}
